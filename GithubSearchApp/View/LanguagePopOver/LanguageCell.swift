//
//  LanguageCell.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/30.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class ProgrammingLanguageCell: UICollectionViewCell {
    
    @IBOutlet weak var languageNameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    
    func  configureCell (languageName: String){
        
        languageNameLabel.text = languageName
    }
    
}

