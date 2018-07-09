//
//  CustomButton.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    fileprivate func configure() {
        self.backgroundColor = UIColor(red: 0.0, green: (122.0/255.0), blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.titleLabel?.textColor = .white
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
}
