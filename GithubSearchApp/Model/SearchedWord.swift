//
//  SearchedWord.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/05/04.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation

class SearchedWord: NSObject, NSCoding {
    
    var word: String!
    var date: String!
    
    init(word: String, date: String) {
        self.word = word
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.word = aDecoder.decodeObject(forKey: "word") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        if let word = word { aCoder.encode(word, forKey: "word") }
        if let date = date { aCoder.encode(date, forKey: "date") }
    }
}
