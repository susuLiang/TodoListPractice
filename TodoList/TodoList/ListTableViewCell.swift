//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by Shu Wei Liang on 2020/4/17.
//  Copyright © 2020 Shu Wei Liang. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
