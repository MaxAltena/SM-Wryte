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
        
        layer.borderWidth = 3/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/4
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
    }
}
