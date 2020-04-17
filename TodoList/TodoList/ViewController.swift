//
//  ViewController.swift
//  TodoList
//
//  Created by Shu Wei Liang on 2020/4/17.
//  Copyright © 2020 Shu Wei Liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
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
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}
