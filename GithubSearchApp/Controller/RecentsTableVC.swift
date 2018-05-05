//
//  RecentsTableVC.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/05/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import ViewAnimator

class RecentsTableVC: UITableViewController {
    
    @IBOutlet weak var initLbl: UILabel!
    var searchedWordArray = [SearchedWord]()
    private let animations = [AnimationType.from(direction: .bottom, offset: 60.0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RecentsTableViewCell",bundle: nil), forCellReuseIdentifier: "RecentsTableViewCell")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let savedArray = Util.loadSearchedWord() {
            initLbl.isHidden = true
            searchedWordArray = savedArray
            tableView.reloadData()
        }else {
            initLbl.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedWordArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentsTableViewCell", for: indexPath) as! RecentsTableViewCell
        cell.configureCell(searchedWordObj: searchedWordArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
