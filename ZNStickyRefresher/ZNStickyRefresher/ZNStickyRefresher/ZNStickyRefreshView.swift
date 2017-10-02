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
    
    private class var stickyViewDefaultStrokePath: UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 15, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
    }
    
    /// store refresh control's height
    var parentViewHeight: CGFloat = 0
    
    /// record current refresh state
    var state: refreshState = .Normal {
        didSet {
            switch state {
            case .Normal:
                // sticky view defalut status
                stickyView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
                stickyView.strokePath = ZNStickyRefreshView.stickyViewDefaultStrokePath
                stickyView.iconScale = 1.0
                
                break;
            case .showStickyEffect:
                stickyView.frame.origin.y = 7
                
                let stretchHeight = parentViewHeight - maxStretchHeight
                
//                if stretchHeight > maxStretchHeight {
//                    if state != .isRefreshing {
//                        state = .isRefreshing
//                    }
//                    
//                    return
//                }

                let stretchScaleFactor = 1 - 0.6 * stretchHeight / maxStretchHeight
                
                stickyView.iconScale = stretchScaleFactor
                
                // top half round
                let strokePath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 15.0 * stretchScaleFactor, startAngle: .pi, endAngle: 2.0 * .pi, clockwise: true)
    
                let bottomRoundCenter = CGPoint(x: 15, y: parentViewHeight - 14 - 15 * stretchScaleFactor * stretchScaleFactor)

                let topRoundXOffset = 15.0 * stretchScaleFactor
                let bottomRoundXOffset = 15.0 * stretchScaleFactor * stretchScaleFactor

                let topCurveLeftControlPoint = CGPoint(x: 15.0 - bottomRoundXOffset, y: 15 + (bottomRoundCenter.y - 15) / 2)
                let topCurveRightControlPoint = CGPoint(x: 15.0 + bottomRoundXOffset, y: 15 + (bottomRoundCenter.y - 15) / 2)
                
                let topRoundLeftPoint = CGPoint(x: 15.0 - topRoundXOffset, y: 15)
                
                // right curve
                let bottomRoundRightPoint = CGPoint(x: bottomRoundCenter.x + bottomRoundXOffset, y: bottomRoundCenter.y)
                strokePath.addQuadCurve(to: bottomRoundRightPoint, controlPoint: topCurveRightControlPoint)
                
                // bottom half round
                strokePath.addArc(withCenter: bottomRoundCenter, radius: 15.0 * stretchScaleFactor * stretchScaleFactor, startAngle: 0, endAngle: .pi, clockwise: true)
                
                // left curve
                strokePath.addQuadCurve(to: topRoundLeftPoint, controlPoint: topCurveLeftControlPoint)
                
                stickyView.strokePath = strokePath

                break;
            case .isRefreshing:
                activityIndicatorView.startAnimating()
                
                
                
            case .failedRefreshing:
                activityIndicatorView.stopAnimating()
                
                self.resultIconView.image = #imageLiteral(resourceName: "failureIcon")
                self.resultInfoLabel.text = "刷新失败"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.resultIconView.isHidden = false
                    self.resultInfoLabel.isHidden = false
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                        self.resultIconView.isHidden = true
                        self.resultInfoLabel.isHidden = true
                    })
                })
                
                break;
            case .succeededRefreshing:
                activityIndicatorView.stopAnimating()
                
                self.resultIconView.image = #imageLiteral(resourceName: "successIcon")
                self.resultInfoLabel.text = "刷新成功"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.resultIconView.isHidden = false
                    self.resultInfoLabel.isHidden = false
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                        self.resultIconView.isHidden = true
                        self.resultInfoLabel.isHidden = true
                    })
                })
                
                break;
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        
        backgroundColor = superview?.backgroundColor
    }
    
    /// return a instance of ZNStickyRefreshView
    ///
    /// - Returns: a instance load from nib file
    class func refreshView() -> ZNStickyRefreshView {
        let nib = UINib(nibName: "ZNStickyRefreshView", bundle: nil)
        
        let refreshView = nib.instantiate(withOwner: nil, options: nil)[0] as! ZNStickyRefreshView
        refreshView.stickyView.fillColor = UIColor.darkGray.withAlphaComponent(0.6)
        refreshView.stickyView.strokePath = stickyViewDefaultStrokePath
        
        return refreshView
    }
}
