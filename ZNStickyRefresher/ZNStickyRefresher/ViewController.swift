//
//  ViewController.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/9/22.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    lazy var stickyRefreshControl: ZNStickyRefreshControl = {
        let result = ZNStickyRefreshControl()
        result.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "测试用例"
        
        tableView.addSubview(stickyRefreshControl)
    }
    
    @objc private func loadData() {
        
    }
}

// MARK: - table view data source
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row)个"
        
        return cell
    }
}

