//
//  ZNStickyRefreshView.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/9/22.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

enum refreshState {
    
    /// original state
    case Normal
    /// end dragging and refresh
    case willRefresh
    /// show refreshing effect
    case isRefreshing
}

/// display refresh effect
class ZNStickyRefreshView: UIView {
    
    @IBOutlet weak var successIconView: UIImageView!
    @IBOutlet weak var successInfoLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var stickyView: UIView!
    @IBOutlet weak var refreshIconView: UIImageView!
    
    /// record current refresh state
    var state: refreshState = .Normal {
        didSet {
            
        }
    }
    
    /// return a instance of ZNStickyRefreshView
    ///
    /// - Returns: a instance load from nib file
    class func refreshView() -> ZNStickyRefreshView {
        let nib = UINib(nibName: "ZNStickyRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! ZNStickyRefreshView
    }
}
