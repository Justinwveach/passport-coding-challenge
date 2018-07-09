//
//  ProfilesDataController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ProfilesDataStore: Store {
    
    var profiles = [Profile]()
    var delegate: StoreDelegate?
    var listener: ListenerRegistration!
    let db = Firestore.firestore()

    init(delegate: StoreDelegate) {
        self.delegate = delegate
        fetchData()
    }
    
    func fetchData() {
        listener = db.collection("profiles").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.profiles.removeAll()
            
            for doc in documents {
                let profile = Profile(docId: doc.documentID, dict: doc.data())
                self.profiles.append(profile)
            }
            
            self.delegate?.didUpdate(store: self)
        }
    }
    
    func filter(_ filters: Set<ProfileFilter>) -> [Profile] {
        let filteredProfiles = profiles.filter { profile in
            var validGender = false
            var validAge = true
            
            for filter in filters {
                switch filter {
                case .female:
                    if profile.gender == .female {
                        validGender = true
                    }
                case .male:
                    if profile.gender == .male {
                        validGender = true
                    }
                case .over30:
                    if profile.age <= 30 {
                        validAge = false
                    }
                }
            }
            return validGender && validAge
        }
        
        return filteredProfiles
    }
    
}
