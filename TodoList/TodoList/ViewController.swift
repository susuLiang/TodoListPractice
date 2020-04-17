//
//  ViewController.swift
//  TodoList
//
//  Created by Shu Wei Liang on 2020/4/17.
//  Copyright © 2020 Shu Wei Liang. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var todoList: [Result] = []
    var database: Database!
    var listQuery: Query!
    var didSelectedUUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.log.console.level = .debug
        self.database = try? Database(name: "localDB")
        
        self.reload()
    }
    
    @IBAction func tapSendButton(_ sender: UIButton) {
           let uuid = self.didSelectedUUID ?? UUID().uuidString
           let doc = MutableDocument(id: uuid)
           doc.setString(uuid, forKey: "uuid")
           doc.setString("list", forKey: "type")
           doc.setString(textField.text, forKey: "title")
           
        // 資料新增/修改存入DB
           do {
               try self.database.saveDocument(doc)
           } catch {
               print("saving document error.")
           }
           
           self.textField.text = nil
           self.didSelectedUUID = nil
       }
    
    func reload() {
        if listQuery == nil {
            listQuery = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(self.database))
                .where(Expression.property("type").equalTo(Expression.string("list")))
            
            listQuery.addChangeListener { (change) in
                guard change.error == nil else { return }
                if let result = change.results {
                    // 取得資料
                    self.todoList = Array(result)
                }
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        if let title = self.todoList[indexPath.row].dictionary(at: 0)?.string(forKey: "title") {
            cell.contentLabel.text = title
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.todoList[indexPath.row].dictionary(at: 0)
        self.didSelectedUUID = data?.string(forKey: "uuid")
        self.textField.text = data?.string(forKey: "title")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let data = self.todoList[indexPath.row].dictionary(at: 0),
                let uuid = data.string(forKey: "uuid"),
                let doc = self.database.document(withID: uuid) {
                do {
                    // 資料刪除
                    try self.database.deleteDocument(doc)
                } catch let error as NSError {
                    print("Couldn't delete the list, error: \(error.debugDescription)")
                }
                self.tableView.reloadData()
            }
        }
    }
    
}
