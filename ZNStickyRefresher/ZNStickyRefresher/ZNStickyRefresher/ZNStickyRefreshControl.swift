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
    fileprivate lazy var refreshView = ZNStickyRefreshView.refreshView()
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let newSuperview = newSuperview as? UIScrollView else { return }
        
        scrollView = newSuperview
        
        // let `self` observe newSuperview's contentOffset
        newSuperview.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // remove observer
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    // FIXME: - KVO call-back
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }
        
        let height = -(scrollView.contentInset.top + scrollView.contentOffset.y)
        
        // drag and drop up from original point
        if height < 0 {
            return
        }
        
        // set refresh control's frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: scrollView.bounds.width,
                            height: height)
        if refreshView.state != .isRefreshing {
            refreshView.parentViewHeight = height
        }
        
        if height > refreshView.bounds.height && scrollView.isDragging {
            refreshView.state = .showStickyEffect
        }
    }
    
    // FIXME: - start refreshing
    func beginRefreshing() {
        
    }
    
    // FIXME: - finish refreshing
    func endRefreshing() {
        
    }
}

extension ZNStickyRefreshControl {
    fileprivate func setUI() {
        addSubview(refreshView)
        
        clipsToBounds = true
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}
