//
//  ResultTableViewCell.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/28.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(rank: Int, word: String, total: Int) {
        rankLbl.text = "  |        \(rank)   |"
        wordLbl.text = "   \(word)"
        countLbl.text = "| \(total) |    "
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
