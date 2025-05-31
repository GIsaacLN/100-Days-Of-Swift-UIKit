//
//  DetailViewController.swift
//  Project16
//
//  Created by Gustavo Isaac Lopez Nunez on 30/05/25.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var capital: Capital?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = capital?.title
        if let city = capital?.urlExtension {
            let url = URL(string: "https://en.wikipedia.org/wiki/" + city)!
            webView.load(URLRequest(url: url))
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
