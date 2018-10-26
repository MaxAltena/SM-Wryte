//
//  RoundedButton.swift
//  Wryte
//
//  Created by Max Altena on 21/09/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 5/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/4
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 12, left: (bounds.width - 40), bottom: 12, right: 12)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -110, bottom: 0, right: (imageView?.frame.width)! + 10)
        }
    }
}
