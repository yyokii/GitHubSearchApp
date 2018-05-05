//
//  Util.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/05/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation

class Util {
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    static func getTodayDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyddMMM", options: 0, locale: nil)
        return formatter.string(from: Date())
    }
    
    static func saveSearchedWord(searchedWord: String){
        let searchedWordObj = SearchedWord(word: searchedWord, date: getTodayDate())
        
        if let savedWordsArray = loadSearchedWord() {
            var saveArray = loadSearchedWord()
            
            if savedWordsArray.count <= 9{
                saveArray?.insert(searchedWordObj, at: 0)
            }else {
                // 要素数が10の場合
                saveArray?.removeLast()
                saveArray?.insert(searchedWordObj, at: 0)
            }
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: saveArray!), forKey: "searchedWords")
        }else {
            // １回目の検索
            var searchedWordArray = [SearchedWord]()
            searchedWordArray.insert(searchedWordObj, at: 0)
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: searchedWordArray), forKey: "searchedWords")
        }
    }
    
    static func loadSearchedWord() -> [SearchedWord]?{
        if let loadedData = UserDefaults().data(forKey: "searchedWords") {
            let loadedWords = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [SearchedWord]
            return loadedWords
        }else {
            return nil
        }
    }
}
