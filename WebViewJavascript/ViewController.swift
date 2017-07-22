//
//  ViewController.swift
//  WebViewJavascript
//
//  Created by admin on 2017/7/21.
//  Copyright © 2017年 w3cmm. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate  {
    
    var webView: WKWebView?
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController();
//        let userScript = WKUserScript(
//            source: "redHeader()",
//            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
//            forMainFrameOnly: true
//        )
//        contentController.addUserScript(userScript)
        contentController.add(
            self,
            name: "callbackHandler"
        )
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView?.navigationDelegate = self;
        self.view.addSubview(webView!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let localfilePath = Bundle.main.url(forResource: "home", withExtension: "html")
        let req = URLRequest(url: localfilePath! as URL)
        self.webView!.load(req)

    }
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? NSDictionary {
            
            let alert = UIAlertController(title: body.object(forKey: "title")! as? String, message: body.object(forKey: "body")! as? String, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // create the alert
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        
        webView.evaluateJavaScript("redHeader()") { (value, error) in
            print(value ?? "")
        }
    }
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        print("runJavaScriptAlertPanelWithMessage")
//        let alertController = UIAlertController(title: "test", message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            completionHandler()
//        }))
//        self.present(alertController, animated: true, completion: nil)
//    }
}

