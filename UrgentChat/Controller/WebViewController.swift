//
//  WebViewController.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 10/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebViewController : UIViewController, WKNavigationDelegate  {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var link : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        activityIndicator.setCornerRadious()
        activityIndicator.setBackgraoundTransparency()
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: link!)!))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)        
    }
    
    /// To manage the activityIndictor appearence
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == K.loading {
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            }
            else {
                activityIndicator.stopAnimating()
            }
        }
    }
}

