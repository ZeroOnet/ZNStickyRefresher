//
//  ZNStickyRefreshControl.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/9/22.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

/// finish refreshing control logic
class ZNStickyRefreshControl: UIControl {
    
    /// refresher's container view
    private weak var scrollView: UIScrollView?
    
    /// refresh view
    private lazy var refreshView = ZNStickyRefreshView.refreshView()
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let newSuperview = newSuperview as? UIScrollView else { return }
        
        scrollView = newSuperview
        
        // let `self` observe newSuperview's contentOffset
        newSuperview.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // FIXME: - KVO call-back
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    // FIXME: - start refreshing
    func beginRefreshing() {
        
    }
    
    // FIXME: - finish refreshing
    func endRefreshing() {
        
    }
}
