//
//  Alert.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/30.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class Alert {
    // アラートを表示する汎用メソッド（ボタン1個）
    public static func presentOneBtnAlert(vc: UIViewController, title: String, message: String, positiveTitle: String, positiveAction: @escaping () -> Void) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        
        let positiveAction: UIAlertAction = UIAlertAction(title: positiveTitle, style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            positiveAction()
        })
        alert.addAction(positiveAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
