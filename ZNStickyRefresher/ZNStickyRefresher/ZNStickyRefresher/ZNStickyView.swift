//
//  ZNStickyView.swift
//  ZNStickyRefresher
//
//  Created by FunctionMaker on 2017/10/1.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

import UIKit

class ZNStickyView: UIView {
    /// default stroke color
    var fillColor: UIColor = UIColor.black
    var iconScale: CGFloat = 0 {
        didSet {
            refreshIconView.transform = CGAffineTransform(scaleX: iconScale, y: iconScale)
        }
    }
    
    var strokePath: UIBezierPath? {
        didSet {
            // update stroke path
            stickyLayer.path = strokePath?.cgPath
            stickyLayer.fillColor = fillColor.cgColor
        }
    }
    
    fileprivate var stickyLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var refreshIconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refreshIcon"))
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stickyLayer.frame = self.bounds
        
        addConstraint(NSLayoutConstraint(item: refreshIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: refreshIconView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: refreshIconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: refreshIconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
    }
}

extension ZNStickyView {
    fileprivate func setUI() {
        refreshIconView.contentMode = .scaleAspectFit
        refreshIconView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.addSublayer(stickyLayer)
        addSubview(refreshIconView)
        
        backgroundColor = UIColor.black
    }
}
