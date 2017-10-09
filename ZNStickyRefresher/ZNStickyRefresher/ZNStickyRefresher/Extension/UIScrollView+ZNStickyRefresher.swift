//
//  UIScrollView+ZNStickyRefresher.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/10/9.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

/// the key to association object
private var stickyRefresherKey: UInt8 = 0

// MARK: - let UIScrollView realize ZNStickyRefresher
extension UIScrollView: ZNStickyRefresher {
    
    var stickyRefreshControl: ZNStickyRefreshControl {
        set {
            /// avoid adding repeated
            stickyRefreshControl.removeFromSuperview()
            
            objc_setAssociatedObject(self, &stickyRefresherKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.addSubview(newValue)
        }
        
        get {
            guard let result = objc_getAssociatedObject(self, &stickyRefresherKey) as? ZNStickyRefreshControl else {
                return ZNStickyRefreshControl()
            }
            
            return result
        }
    }
}
