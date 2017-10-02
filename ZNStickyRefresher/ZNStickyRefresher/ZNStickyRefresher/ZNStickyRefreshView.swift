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
    
    @IBOutlet weak var stickyView: ZNStickyView!
    
    @IBOutlet weak var resultIconView: UIImageView!
    @IBOutlet weak var resultInfoLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let maxStretchHeight: CGFloat = 44
    
    /// store refresh control's height
    var parentViewHeight: CGFloat = 0
    
    /// record current refresh state
    var state: refreshState = .Normal {
        didSet {
            switch state {
            case .Normal:
                stickyView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
                
                break;
            case .showStickyEffect:
                stickyView.frame.origin.y = 7
                stickyView.frame.size.height = parentViewHeight - 14;
                
                let stretchHeight = parentViewHeight - maxStretchHeight
                
                if stretchHeight > maxStretchHeight {
                    return
                }

                let stretchScaleFactor = 1 - 0.4 * stretchHeight / maxStretchHeight
                
                stickyView.iconScale = stretchScaleFactor
                
                // top half round
                let strokePath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 15.0 * stretchScaleFactor, startAngle: .pi, endAngle: 2.0 * .pi, clockwise: true)
    
                let bottomRoundCenter = CGPoint(x: 15, y: stickyView.bounds.height - 15 * stretchScaleFactor * stretchScaleFactor)

                let topRoundXOffset = 15.0 * stretchScaleFactor
                let bottomRoundXOffset = 15.0 * stretchScaleFactor * stretchScaleFactor

                let topCurveLeftControlPoint = CGPoint(x: 15.0 - 0.8 * topRoundXOffset, y: 15 + 0.9 * topRoundXOffset)
                let topCurveRightControlPoint = CGPoint(x: 15.0 + 0.8 * topRoundXOffset, y: 15 + 0.9 * topRoundXOffset)
                
//                let leftCurveToPoint = CGPoint(x: 15 - bottomRoundXOffset * 1.1, y: (bottomRoundCenter.y - 15) * 0.8 + 15)
//                let rightCurveToPoint = CGPoint(x: 15 + bottomRoundXOffset * 1.1, y: (bottomRoundCenter.y - 15) * 0.8 + 15)


                let topRoundLeftPoint = CGPoint(x: 15.0 - topRoundXOffset, y: 15)
                
                let bottomRoundLeftPoint = CGPoint(x: bottomRoundCenter.x - bottomRoundXOffset, y: bottomRoundCenter.y)

                let bottomRoundRightPoint = CGPoint(x: bottomRoundCenter.x + bottomRoundXOffset, y: bottomRoundCenter.y)
                strokePath.addQuadCurve(to: bottomRoundRightPoint, controlPoint: topCurveRightControlPoint)
//                strokePath.addLine(to: bottomRoundRightPoint)
                
                // bottom half round
                strokePath.addArc(withCenter: bottomRoundCenter, radius: 15.0 * stretchScaleFactor * stretchScaleFactor, startAngle: 0, endAngle: .pi, clockwise: true)
                strokePath.move(to: topRoundLeftPoint)
                
                strokePath.addQuadCurve(to: bottomRoundLeftPoint, controlPoint: topCurveLeftControlPoint)
//                strokePath.addLine(to: bottomRoundLeftPoint)
                
                stickyView.strokePath = strokePath

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
        
        let refreshView = nib.instantiate(withOwner: nil, options: nil)[0] as! ZNStickyRefreshView
        refreshView.stickyView.fillColor = UIColor.lightGray
        refreshView.stickyView.strokePath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 15, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
        
        return refreshView
    }
}
