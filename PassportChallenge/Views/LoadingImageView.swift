//
//  LoadingImageView.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {

    var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        activityIndicator = UIActivityIndicatorView(frame: self.bounds)
        if image == nil {
            self.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    override var image: UIImage? {
        didSet {
            activityIndicator?.stopAnimating()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
