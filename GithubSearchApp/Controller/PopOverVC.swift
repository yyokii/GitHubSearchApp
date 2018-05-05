//
//  PopOverVC.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/30.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

protocol PopOverContentDelegate: class {
    func didSelectedItem(text: String)
}

class PopOverVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!
    var contentArry = LANGUAGES
    
    weak var customDelegate: PopOverContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contentArry.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as? ProgrammingLanguageCell {
            cell.configureCell(languageName: self.contentArry[indexPath.row])
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 選択したものをPostVCに渡す
        self.customDelegate?.didSelectedItem(text: contentArry[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.4, height: 50)
    }
    
}
