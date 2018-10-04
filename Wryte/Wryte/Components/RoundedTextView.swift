//
//  RoundedTextVew.swift
//  Wryte
//
//  Created by Max Altena on 04/10/2018.
//  Copyright © 2018 Max Altena. All rights reserved.
//

import UIKit

class RoundedTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 4/UIScreen.main.nativeScale
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/15
        layer.borderColor = tintColor.cgColor
    }
}
