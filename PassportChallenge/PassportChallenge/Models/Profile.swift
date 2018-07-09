//
//  Profile.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

struct Profile: Codable {
    
    var id = ""
    var name = ""
    var gender: Gender = .unknown
    var age = 1
    var image = ""
    var hobbies = [String]() {
        didSet {
            // Not called inside init so moving to get in hobbiesDescription
            // hobbiesDescription = hobbies.joined(separator: ", ")
        }
    }
    
    var hobbiesDescription: String {
        get {
            if hobbies.isEmpty {
                return "No hobbies..."
            } else {
                return hobbies.joined(separator: ", ")
            }
        }
    }
    
}

extension Profile: FirebaseDecodable {
    
    init(docId: String, dict: [String : Any]) {
        self.id = docId
        
        for (key, value) in dict {
            switch key {
            case "name":
                if let name = value as? String {
                    self.name = name
                }
            case "gender":
                if let gender = value as? String {
                    self.gender = Gender(rawValue: gender)!
                }
            case "age":
                if let age = value as? Int {
                    self.age = age
                }
            case "image":
                if let image = value as? String {
                    self.image = image
                }
            case "hobbies":
                if let hobbies = value as? [String] {
                    self.hobbies = hobbies
                }
            default:
                print("Unknown Key")
            }
        }
    }
    
}
