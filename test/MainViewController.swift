//
//  ViewController.swift
//  test
//
//  Created by macbook on 2019/10/10.
//  Copyright © 2019年 macbook. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate, WKUIDelegate {
    var articles: [[String: String?]] = []
    var webView: WKWebView!
    var activityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func backButton(_ sender: Any) {
        self.webView.goBack()
    }
    @IBAction func forwardButton(_ sender: Any) {
        self.webView.goForward()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func homeButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getArticles()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items")
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string,
                        "url": json["url"].string,
                    ]
                    self.articles.append(article)
                    print(article)
                }
                self.tableView.reloadData()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = articles[indexPath.row]
        let url = cell["url"]!
        
        webView = WKWebView(frame: CGRect( x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height), configuration: WKWebViewConfiguration())
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["userId"]!
        return cell
    }
}


