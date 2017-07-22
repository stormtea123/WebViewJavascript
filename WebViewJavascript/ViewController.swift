//
//  ViewController.swift
//  WebViewJavascript
//
//  Created by admin on 2017/7/21.
//  Copyright © 2017年 w3cmm. All rights reserved.
//

import UIKit
import WebKit
extension URL {
    func valueOf(queryParamaterName: String) -> String? {
        
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

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
        self.webView?.uiDelegate = self;
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
            
            let alert = UIAlertController(title: body.object(forKey: "title")! as? String, message: body.object(forKey: "message")! as? String, preferredStyle: UIAlertControllerStyle.alert)
            
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
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (_) in}
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (_) in
            completionHandler(((alert.textFields?.last?.text) != nil))
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        let scheme = url?.scheme
        let method = url?.host
        let query = url?.query
        
        if url != nil && scheme == "jsbridge" {
            switch method! {
            case "alert":
                //url.valueOf("test1")
                let alert = UIAlertController(title: url?.valueOf(queryParamaterName: "title"), message: url?.valueOf(queryParamaterName: "message"), preferredStyle: UIAlertControllerStyle.alert)
                
                //add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            default:
                print("default")
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
    
}

