//
//  ProfilesDataSource.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class ProfilesDataSource: NSObject {
    
    // Contains all of our profiles
    fileprivate var allProfiles = [Profile]()
    
    // In memory image cache so that the image isnt downloaded on every reloadData()
    fileprivate var imageCache = [String: UIImage]()
    
    // contains profiles that will be sorted or filtered
    var profiles = [Profile]() {
        didSet {
            self.allProfiles = profiles
        }
    }
    
    init(_ profiles: [Profile]) {
        //self.allProfiles = profiles
        self.profiles = profiles
    }
    
}

extension ProfilesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        let profile = profiles[indexPath.row]
        cell.name = profile.name
        cell.age = profile.age
        cell.gender = profile.gender
        cell.hobbies = profile.hobbiesDescription
        
        if imageCache[profile.image] == nil {
            if let url = URL(string: profile.image) {
                let task = URLSession.shared.dataTask(with: url) { [weak cell, weak self] data, response, error in
                    DispatchQueue.main.async {
                        guard let strongCell = cell,
                              let strongSelf = self else {
                            return
                        }
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let data = data {
                            let image = UIImage(data: data)
                            strongCell.profileImage = image
                            strongSelf.imageCache[profile.image] = image
                            //self.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        } else {
            print("Using image stored in cache.")
            let cachedImage = imageCache[profile.image]
            cell.profileImage = cachedImage
        }
        //cell.profileImage = profile.image
        return cell
    }
    
}
