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
        let localfilePath = Bundle.main.url(forResource: "home", withExtension: "html")
        let requestObj = URLRequest(url: localfilePath! as URL)
        webView.loadRequest(requestObj)
        webView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestString: NSString = (request.url?.absoluteString)! as NSString
        print(requestString)
        let components: [String] = requestString.components(separatedBy: ":")
        // Check for your protocol
        if components.count > 1 && (String(components[0]) == "myapp") {
            // Look for specific actions
            if (String(components[1]) == "alert") {
                // Your parameters can be found at
                //   [components objectAtIndex:n]
                print("myaction");
                // create the alert
                let alert = UIAlertController(title: String(components[2]), message: "Lauching this missile will destroy the entire universe. Is this what you intended to do?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
//                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Remind Me Tomorrow", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Launch the Missile", style: UIAlertActionStyle.destructive, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    // 该方法是在UIWebView在开发加载时调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start")
    }
    
    // 该方法是在UIWebView加载完之后才调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finished")
        let title:String = webView.stringByEvaluatingJavaScript(from: "document.title")!
        print("title:\(title)" )
        //redHeader
        webView.stringByEvaluatingJavaScript(from: "redHeader()")
    }
    
    // 该方法是在UIWebView请求失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("fail")
    }



}

