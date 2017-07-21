//
//  ViewController.swift
//  WebViewJavascript
//
//  Created by admin on 2017/7/21.
//  Copyright © 2017年 w3cmm. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let localfilePath = Bundle.main.url(forResource: "home", withExtension: "html");
        let requestObj = URLRequest(url: localfilePath! as URL);
        webView.loadRequest(requestObj);
        webView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("开始加载")
    }
    
    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("加载完成")
    }
    
    // 该方法是在UIWebView请求失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("加载失败")
    }



}

