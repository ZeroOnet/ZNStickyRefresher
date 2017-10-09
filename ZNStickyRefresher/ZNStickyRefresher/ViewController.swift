//
//  ViewController.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/9/22.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    fileprivate var cellsCount = 1
    
    lazy var stickyRefreshControl: ZNStickyRefreshControl = {
        let result = ZNStickyRefreshControl()
        result.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Demo Test"
        
        tableView.stickyRefreshControl = stickyRefreshControl
    }
    
    @objc private func loadData() {
        // simulate network time waste
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
            self.cellsCount += 1
            
            self.tableView.reloadData()
            
            // if refresh failed, modify result tag that default is true.
            //self.stickyRefreshControl.isSuccessful = false
            
            self.stickyRefreshControl.endRefreshing()
        }
    }
}

// MARK: - table view data source
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        cell.textLabel?.text = "case \(indexPath.row)"
        
        return cell
    }
}

