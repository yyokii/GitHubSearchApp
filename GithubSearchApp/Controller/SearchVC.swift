//
//  SearchVC.swift
//  GithubSearchApp
//
//  Created by Yoki Higashihara on 2018/04/21.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PKHUD
import PopupDialog
import BWWalkthrough

class SearchVC: UIViewController, BWWalkthroughViewControllerDelegate{

    @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var languageBtn: UIButton!

    var searchResultDic: Dictionary<String, Int> = [:]
    var selectedLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkFirstTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkFirstTime(){
        if UserDefaults.standard.string(forKey: IS_FIRST) == nil {
            presentGitAuthAlert()
        }
    }
    
    func presentGitAuthAlert(){
        Alert.presentOneBtnAlert(vc: self, title: "Githubと連携します🙇", message: "検索機能を使用するために\n一度だけGithubにログインをお願いします:)\n", positiveTitle: "OK", positiveAction: {
            [weak self] in
            UserDefaults.standard.set(true, forKey: IS_FIRST)
            
            let webViewStoryboard = UIStoryboard(name: "WebView", bundle: nil)
            let webView = webViewStoryboard.instantiateInitialViewController()
            self?.present(webView!, animated: true, completion: nil)
            
        })
    }

    func searchCode() {
        if UserDefaults.standard.string(forKey: ACCESS_TOKEN) == nil {
            presentGitAuthAlert()
            return
        }
        
        HUD.show(.progress)
        let inputText = searchTextField.text
        let searchWordArray = inputText?.split{$0 == " "}.map(String.init)
        
        let githubAPIManager = GithubAPIManager.sharedManager
        githubAPIManager.doMultiAsyncProcess(searchWords: searchWordArray!, language: selectedLanguage, completion: {
            [weak self] (searchResultDic) in
            self?.searchResultDic = searchResultDic
            Util.saveSearchedWord(searchedWord: inputText!)
            HUD.flash(.success, delay: 0.5)
            self?.showCustomDialog()
        })
    }
    
    // 結果表示用のダイアログを表示
    func showCustomDialog(animated: Bool = true) {
        let resultVC = ResultVC(nibName: "Result", bundle: nil)
        resultVC.searchResultDic = self.searchResultDic
        let popup = PopupDialog(viewController: resultVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        let buttonOne = CancelButton(title: "OK", height: 50) {}
        popup.addButtons([buttonOne])
        present(popup, animated: animated, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.searchTextField.isFirstResponder) {
            self.searchTextField.resignFirstResponder()
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        let inputText = searchTextField.text
        guard inputText != ""  else {
            return
        }
        searchCode()
    }
    
    @IBAction func languageTapped(_ sender: Any) {
        showPopOver()
    }
    
    // 言語選択のポップアップを表示
    func showPopOver(){
        let storyBoard = UIStoryboard(name: "PopOver", bundle: nil)
        let contentVC = storyBoard.instantiateInitialViewController() as! PopOverVC
        contentVC.modalPresentationStyle = .popover
        contentVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)
        // popoverのipad時ケア
        contentVC.popoverPresentationController?.sourceView = languageBtn
        contentVC.popoverPresentationController?.permittedArrowDirections = .up
        contentVC.popoverPresentationController?.sourceRect = languageBtn.frame

        contentVC.popoverPresentationController?.delegate = self
        contentVC.customDelegate = self
        present(contentVC, animated: true, completion: nil)
    }
    
    @IBAction func showWebViewTapped(_ sender: Any) {
        let webViewStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        let webView = webViewStoryboard.instantiateInitialViewController()
        present(webView!, animated: true, completion: nil)
    }
    // チュートリアル画面のテスト　→ 結局いらないからつかってない
    @IBAction func showBtnTapped(_ sender: Any) {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        self.present(walkthrough, animated: true, completion: nil)
    }
}

extension SearchVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        let inputText = searchTextField.text
        guard inputText != ""  else {
            return true
        }
        searchCode()
        return true
    }
}

extension SearchVC: UIPopoverPresentationControllerDelegate, PopOverContentDelegate{
    
    /// ポップオーバーをiPhoneで表示させる
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func didSelectedItem(text: String) {
        selectedLanguage = text
        languageBtn.setTitle(text, for: .normal)
    }
}
