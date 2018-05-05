//
//  RecentsTableViewCell.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/05/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class RecentsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var wordLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(searchedWordObj: SearchedWord) {
        wordLbl.text = searchedWordObj.word
        dateLbl.text = searchedWordObj.date
    }
}
