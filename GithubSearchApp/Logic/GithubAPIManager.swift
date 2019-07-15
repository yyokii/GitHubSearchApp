//
//  GithubAPIManager.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/21.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class GithubAPIManager {
    var clientId = ""
    var clientSecret = ""
    var code: String!
    //var accessToken: String?
    
    static let sharedManager = GithubAPIManager()
    
    func oAuthGithub(){
        let url = "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=public_repo"
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    /// アクセストークンを取得
    ///
    /// - Parameter code: このコードとアクセストークンを交換
    func getAccessToken(code: String!, completion: @escaping () -> Void) {
        self.code = code
        let url = "https://github.com/login/oauth/access_token"
        
        let headers = [
            "ACCEPT": "application/json"
        ]
        
        let parameters: Parameters = [
            "client_id": self.clientId,
            "client_secret": self.clientSecret,
            "code": self.code
            ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                let accessToken = json["access_token"].string
                UserDefaults.standard.set(accessToken!, forKey: ACCESS_TOKEN)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func doMultiAsyncProcess(searchWords: [String], language: String, completion: @escaping ( Dictionary<String, Int>) -> Void) {
        var searchResultDic: Dictionary<String, Int> = [:]

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        // 複数の非同期処理を実行
        for word in searchWords {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                [weak self] in
                self?.searchCode(searchWord: word, language: language, completion: {(totalCount) in
                    print("\(word) 検索 End")
                    searchResultDic[word] = totalCount
                    dispatchGroup.leave()
                })
            }
        }
        // 全ての非同期処理完了後
        dispatchGroup.notify(queue: .main) {
            print("All Process Done!")
            // FIXME: ここnon-esc 、なぜなぜ
            completion(searchResultDic)
        }
    }
    
    func searchCode(searchWord: String, language: String, completion: @escaping (Int) -> Void) {
        print("\(searchWord) 検索 Start")

        var url = ""
        if(language != "" && language != "ALL"){
            url = "https://api.github.com/search/code?q=\(searchWord)+language:\(language)+in:file"
        }else {
            url = "https://api.github.com/search/code?q=\(searchWord)+in:file"
        }
        
        if let accessToken = UserDefaults.standard.string(forKey: ACCESS_TOKEN){
            let headers = [
                "Authorization": "token " + accessToken
            ]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let totalCount = json["total_count"].int
                    completion(totalCount!)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            // FIXME: 通信できないよ
        }
    }
}
