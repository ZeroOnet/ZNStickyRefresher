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
    
    /// refresh result tag
    var isSuccessful = false
    
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
        
        let isRefreshing = refreshView.state == .isRefreshing
        
        let topInset = isRefreshing ? 64 : scrollView.contentInset.top
        
        let height = -(topInset + scrollView.contentOffset.y)
        
        // drag and drop up from original point
        if height < 0 {
            return
        }
        
        // set refresh control's frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: scrollView.bounds.width,
                            height: height)
        
        // FIXME: - the issue of jumping frame
        if !isRefreshing {
            refreshView.parentViewHeight = height
        } else {
            return
        }
        
        if height >= 44 && scrollView.isDragging && height <= 88{
            refreshView.state = .showStickyEffect
        } else if height < 44 {
            refreshView.state = .Normal
        } else if height > 88 && refreshView.state != .isRefreshing {
            print(self.frame)
            beginRefreshing()
            
            sendActions(for: .valueChanged)
        }
    }
    
    // FIXME: - start refreshing
    func beginRefreshing() {
        print("begin refreshing")
        
        guard let scrollView = scrollView else { return }
        
        if refreshView.state == .isRefreshing {
            return
        }
        
        refreshView.state = .isRefreshing
        
        var contentInset = scrollView.contentInset
        contentInset.top += 44
        scrollView.contentInset = contentInset
        
        print(self.frame)
        
        refreshView.parentViewHeight = 44
    }
    
    // FIXME: - finish refreshing
    func endRefreshing() {
        guard let scrollView = scrollView else { return }
        
        if refreshView.state != .isRefreshing {
            return
        }
        
        refreshView.state = isSuccessful ? .succeededRefreshing : .failedRefreshing
        
        
        var contentInset = scrollView.contentInset
        contentInset.top -= 44
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 0.5) {
                scrollView.contentInset = contentInset
            }
        }
        
        refreshView.parentViewHeight = 0
        
        refreshView.state = .Normal
    }
}

extension ZNStickyRefreshControl {
    fileprivate func setUI() {
        addSubview(refreshView)
        backgroundColor = UIColor.gray
//        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
}
