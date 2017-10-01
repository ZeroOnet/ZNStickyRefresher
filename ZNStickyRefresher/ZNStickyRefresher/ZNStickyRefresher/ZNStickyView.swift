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
    
    var strokePath: UIBezierPath? {
        didSet {
            // update stroke path
            stickyLayer?.path = strokePath?.cgPath
            stickyLayer?.fillColor = fillColor.cgColor
        }
    }
    
    fileprivate var stickyLayer: CAShapeLayer?
    fileprivate var refreshIconView: UIImageView?
    
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
        
        stickyLayer?.frame = self.bounds
        refreshIconView?.frame = self.bounds.insetBy(dx: 5, dy: 5)
    }
}

extension ZNStickyView {
    fileprivate func setUI() {
        stickyLayer = CAShapeLayer()
        
        refreshIconView = UIImageView(image: #imageLiteral(resourceName: "refreshIcon"))
        refreshIconView!.contentMode = .scaleAspectFit
        
        layer.addSublayer(stickyLayer!)
        addSubview(refreshIconView!)
    }
}
