//
//  ResultVC.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/29.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var resultTableView: UITableView!
    
    var searchResultDic: Dictionary<String, Int> = [:]
    var sortedResultArray: [(key: String, value: Int)]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(UINib(nibName: "ResultTableViewCell",bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        resultTableView.separatorColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sortedResultArray = self.searchResultDic.sorted{ $0.value > $1.value }
        resultTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ResultVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        cell.configureCell(rank: indexPath.row, word: sortedResultArray[indexPath.row].key, total: sortedResultArray[indexPath.row].value)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
