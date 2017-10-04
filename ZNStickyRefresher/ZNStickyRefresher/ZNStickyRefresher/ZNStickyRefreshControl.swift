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
    var isSuccessful = true
    
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
        
        if !isRefreshing {
            refreshView.parentViewHeight = height
        } else {
            return
        }
        
        if height >= 44 && scrollView.isDragging && height <= 88{
            refreshView.state = .showStickyEffect
        } else if height < 44 {
            refreshView.state = .normal
        } else if height > 88 && refreshView.state != .isRefreshing {
            beginRefreshing()
        }
    }
    
    // start refreshing
    func beginRefreshing() {
        print("begin refreshing")
        
        guard let scrollView = scrollView else { return }
        
        if refreshView.state == .isRefreshing {
            return
        }
        
        refreshView.state = .isRefreshing
        
        adjustScrollViewContentInset(withScrollView: scrollView, isEnd: false, completion: nil)
    
        sendActions(for: .valueChanged)
    }
    
    // finish refreshing
    func endRefreshing() {
        guard let scrollView = scrollView else { return }
        
        if refreshView.state != .isRefreshing {
            return
        }
        
        refreshView.state = isSuccessful ? .succeededRefreshing : .failedRefreshing
        
        adjustScrollViewContentInset(withScrollView: scrollView, isEnd: true) { 
            self.refreshView.state = .original
        }
        
        print("end refreshing")
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
    
    fileprivate func adjustScrollViewContentInset(withScrollView: UIScrollView, isEnd: Bool, completion:(()->())?) {
        var contentInset = withScrollView.contentInset
        contentInset.top += (isEnd ? -44 : 44)
        
        if !isEnd {
            withScrollView.contentInset = contentInset
            
            // fix the issue of jumping frame
            withScrollView.contentOffset.y -= 44
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    withScrollView.contentInset = contentInset
                }, completion: { _ in
                    completion?()
                })
            }
        }
    }
}
