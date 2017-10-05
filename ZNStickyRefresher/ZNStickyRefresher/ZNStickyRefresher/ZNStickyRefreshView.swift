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
    case original
    
    /// start pulling
    case normal
    
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
    
    private let stickyViewStrokeRadius: CGFloat = 15
    private let stickyViewOriginY: CGFloat = 7
    
    private let maxScaleFactor: CGFloat = 0.6
    
    fileprivate var stickyViewDefaultStrokePath: UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: stickyViewStrokeRadius, y: stickyViewStrokeRadius), radius: stickyViewStrokeRadius, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
    }
    
    /// store refresh control's height
    var parentViewHeight: CGFloat = 0
    
    /// record current refresh state
    var state: refreshState = .original {
        didSet {
            switch state {
            case .original:
                stickyView.frame.size.height = 2.0 * stickyViewStrokeRadius
                stickyView.alpha = 1.0
                resultIconView.alpha = 0
                resultInfoLabel.alpha = 0
                
                break
            case .normal:
                // sticky view defalut status
                stickyView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
                
                stickyView.strokePath = stickyViewDefaultStrokePath
                stickyView.iconScale = 1.0
                
                print("normal")
                
                break
            case .showStickyEffect:
                stickyView.frame.origin.y = stickyViewOriginY
                stickyView.frame.size.height = parentViewHeight - stickyViewOriginY * 2.0
                
                let stretchHeight = parentViewHeight - maxStretchHeight
                
                let stretchScaleFactor = 1 - maxScaleFactor * stretchHeight / maxStretchHeight
                
                stickyView.iconScale = stretchScaleFactor
                
                // top half round
                let strokePath = UIBezierPath(arcCenter: CGPoint(x: stickyViewStrokeRadius, y: stickyViewStrokeRadius), radius: stickyViewStrokeRadius * stretchScaleFactor, startAngle: .pi, endAngle: 2.0 * .pi, clockwise: true)
    
                let bottomRoundCenter = CGPoint(x: stickyViewStrokeRadius, y: parentViewHeight - 2.0 * stickyViewOriginY - stickyViewStrokeRadius * stretchScaleFactor * stretchScaleFactor)

                let topRoundXOffset = stickyViewStrokeRadius * stretchScaleFactor
                let bottomRoundXOffset = stickyViewStrokeRadius * stretchScaleFactor * stretchScaleFactor

                let topCurveLeftControlPoint = CGPoint(x: stickyViewStrokeRadius - bottomRoundXOffset, y: stickyViewStrokeRadius + (bottomRoundCenter.y - stickyViewStrokeRadius) / 2)
                let topCurveRightControlPoint = CGPoint(x: stickyViewStrokeRadius + bottomRoundXOffset, y: stickyViewStrokeRadius + (bottomRoundCenter.y - stickyViewStrokeRadius) / 2)
                
                let topRoundLeftPoint = CGPoint(x: stickyViewStrokeRadius - topRoundXOffset, y: stickyViewStrokeRadius)
                
                // right curve
                let bottomRoundRightPoint = CGPoint(x: bottomRoundCenter.x + bottomRoundXOffset, y: bottomRoundCenter.y)
                strokePath.addQuadCurve(to: bottomRoundRightPoint, controlPoint: topCurveRightControlPoint)
                
                // bottom half round
                strokePath.addArc(withCenter: bottomRoundCenter, radius: stickyViewStrokeRadius * stretchScaleFactor * stretchScaleFactor, startAngle: 0, endAngle: .pi, clockwise: true)
                
                // left curve
                strokePath.addQuadCurve(to: topRoundLeftPoint, controlPoint: topCurveLeftControlPoint)
                
                stickyView.strokePath = strokePath

                break
            case .isRefreshing:
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.stickyView.alpha = 0
                    self.stickyView.frame.size.height = 0
                    
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.activityIndicatorView.startAnimating()
                    }
                })
                
            case .failedRefreshing:
                showRefreshStatus(isSuccessful: false)
                
                break
            case .succeededRefreshing:
                showRefreshStatus(isSuccessful: true)
                
                break
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        backgroundColor = superview?.backgroundColor
    }
}

extension ZNStickyRefreshView {
    /// return a instance of ZNStickyRefreshView
    ///
    /// - Returns: a instance load from nib file
    class func refreshView() -> ZNStickyRefreshView {
        let nib = UINib(nibName: "ZNStickyRefreshView", bundle: nil)
        
        let refreshView = nib.instantiate(withOwner: nil, options: nil)[0] as! ZNStickyRefreshView
        refreshView.stickyView.fillColor = UIColor.darkGray.withAlphaComponent(0.6)
        refreshView.stickyView.strokePath = refreshView.stickyViewDefaultStrokePath
        
        return refreshView
    }
    
    fileprivate func showRefreshStatus(isSuccessful: Bool) {
        activityIndicatorView.stopAnimating()
        
        self.resultIconView.image = isSuccessful ? #imageLiteral(resourceName: "successIcon") : #imageLiteral(resourceName: "failureIcon")
        self.resultInfoLabel.text = isSuccessful ? "刷新成功" : "刷新失败"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.resultIconView.alpha = 1
            self.resultInfoLabel.alpha = 1
        })
    }
}
