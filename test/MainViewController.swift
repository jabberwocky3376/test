//
//  ViewController.swift
//  test
//
//  Created by macbook on 2019/10/29.
//  Copyright © 2019年 macbook. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticles()
    }
    
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items")
        .responseJSON { response in
            print(response.result.value)
        }
    }
}

extension MainViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
