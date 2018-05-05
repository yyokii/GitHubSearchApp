//
//  WebVC.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/05/02.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class WebVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        applyIndicator()
        
        // ここのwebViewはgit認証の際にしか（現状）使用しないので、urlは決め打ちにしています
        let gitOuthUrl = URL(string: "https://github.com/login/oauth/authorize?client_id=b66ee9abedea5103b809&scope=public_repo")
        let gitOuthRequest = URLRequest(url: gitOuthUrl!)
        titleLbl.text = "Github連携"
        
        webView.load(gitOuthRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applyIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        // 見やすくするために-150だけyをずらしてます
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2 - 150)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.webView.addSubview(activityIndicator)
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {        
        if navigationAction.request.url?.scheme == "yyokii", navigationAction.request.url?.host == "GithubSearchApp"{
            dismiss(animated: true, completion: nil)
            HUD.show(.progress)
            let code = Util.getQueryStringParameter(url: (navigationAction.request.url?.absoluteString)!, param: "code")
            let githubAPIManager = GithubAPIManager.sharedManager
            githubAPIManager.getAccessToken(code: code, completion: {
                HUD.flash(.success, delay: 0.5)
            })
        }
        //これいれないとcrashする
        decisionHandler(WKNavigationActionPolicy.allow);
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
