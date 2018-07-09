//
//  ProfileTableViewCell.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "profileCell"
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var ageLabel: UILabel!
    @IBOutlet private var genderView: UIView!
    @IBOutlet private var profileImageView: LoadingImageView!
    @IBOutlet private var hobbiesLabel: UILabel!
    
    var name: String? {
        didSet {
            self.nameLabel.text = name
        }
    }
    
    var age: Int? {
        didSet {
            self.ageLabel.text = "\(age ?? 0) years old"
        }
    }
    
    var gender: Gender? {
        didSet {
            switch gender! {
            case .female:
                self.genderView.backgroundColor = UIColor(red: (248.0/255.0), green: (145.0/255.0), blue: (160.0/255.0), alpha: 1.0)
            case .male:
                self.genderView.backgroundColor = UIColor(red: (193.0/255.0), green: (222.0/255.0), blue: (231.0/255.0), alpha: 1.0)
            default:
                self.genderView.backgroundColor = .white
            }
        }
    }
    
    var hobbies: String? {
        didSet {
            self.hobbiesLabel.text = hobbies
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            self.profileImageView.image = profileImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
