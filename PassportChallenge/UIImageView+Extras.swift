//
//  UIImageView+Extras.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func image(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(frame: self.bounds)
        if image == nil {
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
}
