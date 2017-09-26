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
    /// display main sticky refresh effect
    case showStickyEffect
    /// show refreshing effect
    case isRefreshing
    
    /// show refreshing result
    case failedRefreshing
    case succeededRefreshing
}

/// display refresh effect
class ZNStickyRefreshView: UIView {
    
    @IBOutlet weak var refreshIconView: UIImageView!
    
    @IBOutlet weak var successIconView: UIImageView!
    @IBOutlet weak var successInfoLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let maxStretchHeight: CGFloat = 44
    private let refreshHUD: CAShapeLayer = CAShapeLayer()
    
    /// store refresh control's height
    var parentViewHeight: CGFloat = 0 {
        didSet {
//            print("paH: \(parentViewHeight)")
//            print("sticY: \(stickyView.frame.origin.y)")
//            print("refreH: \(self.bounds.height)")
        }
    }
    
    /// record current refresh state
    var state: refreshState = .Normal {
        didSet {
            switch state {
            case .Normal:
                break;
            case .showStickyEffect:
                // show refresh sticky effect
                let stretchHeight = (parentViewHeight - self.bounds.height) / 2
                
                if stretchHeight > maxStretchHeight {
                    // will refresh
                    
                    
                    return
                }
                
                let stretchScaleFactor = 1 - 0.5 * stretchHeight / maxStretchHeight
                
                refreshIconView.transform = CGAffineTransform(scaleX: stretchScaleFactor, y: stretchScaleFactor)
                refreshIconView.center.y = 13 - stretchHeight
                refreshHUD.position.y = 7 + 15 - stretchHeight
                
                // top round
                
                let strokePath = UIBezierPath()
                
                strokePath.move(to: refreshHUD.position)
                strokePath.addArc(withCenter: CGPoint(x: 15, y: 15) , radius: 15 * stretchScaleFactor, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
//                let bottomRoundCenter = CGPoint(x: refreshIconView.center.x, y: parentViewHeight - 15 - 7)
//                strokePath.move(to: bottomRoundCenter)

                // bottom round
//                strokePath.addArc(withCenter: bottomRoundCenter, radius: 13.0 * stretchScaleFactor, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
//
//                let curveControlPoint = CGPoint(x: refreshIconView.center.x, y: refreshIconView.center.y + (bottomRoundCenter.y - refreshIconView.center.y) / 2)
//
//                let topRoundXOffset = 15 - 15 * stretchScaleFactor
//                let bottomRoundXOffset = 13 - 13 * stretchScaleFactor
//
//                let topRoundLeftPoint = CGPoint(x: refreshIconView.center.x - topRoundXOffset, y: refreshIconView.center.y)
//                let bottomRoundLeftPoint = CGPoint(x: bottomRoundCenter.x - bottomRoundXOffset, y: bottomRoundCenter.y)
//                let topRoundRightPoint = CGPoint(x: refreshIconView.center.x + topRoundXOffset, y: refreshIconView.center.y)
//                let bottomRoundRightPoint = CGPoint(x: bottomRoundCenter.x + bottomRoundXOffset, y: bottomRoundCenter.y)
//                
//                strokePath.move(to: topRoundLeftPoint)
//                strokePath.addQuadCurve(to: bottomRoundLeftPoint, controlPoint: curveControlPoint)
//                
//                strokePath.move(to: topRoundRightPoint)
//                strokePath.addQuadCurve(to: bottomRoundRightPoint, controlPoint: curveControlPoint)
//                
                refreshHUD.path = strokePath.cgPath
                break;
            case .isRefreshing:
                activityIndicatorView.startAnimating()
            case .failedRefreshing:
                break;
            case .succeededRefreshing:
                break;
            }
        }
    }
    
    /// return a instance of ZNStickyRefreshView
    ///
    /// - Returns: a instance load from nib file
    class func refreshView() -> ZNStickyRefreshView {
        let nib = UINib(nibName: "ZNStickyRefreshView", bundle: nil)
        
        // its frame is effective
        let refreshView = nib.instantiate(withOwner: nil, options: nil)[0] as! ZNStickyRefreshView
        refreshView.refreshHUD.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshView.refreshHUD.position = refreshView.center
        refreshView.refreshHUD.fillColor = UIColor.lightGray.cgColor
        
        let originalPath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 15, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
        
        refreshView.refreshHUD.path = originalPath.cgPath
        
        refreshView.layer.insertSublayer(refreshView.refreshHUD, below: refreshView.refreshIconView.layer)
        
        return refreshView
    }
}
