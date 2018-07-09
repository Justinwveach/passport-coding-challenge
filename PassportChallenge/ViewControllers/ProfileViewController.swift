//
//  ProfileViewController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {

    static let identifier = "profileViewController"
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var ageLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var hobbiesLabel: UILabel!
    @IBOutlet private var profileImageLabel: UILabel!
    
    var profileId: String = ""
    
    fileprivate var profile: Profile? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                guard let profile = self.profile else {
                    self.nameLabel.text = "N/A"
                    self.ageLabel.text = "N/A"
                    self.genderLabel.text = "N/A"
                    self.hobbiesLabel.text = "N/A"
                    self.profileImageLabel.text = "N/A"
                    return
                }
                
                self.nameLabel.text = "Name: \(profile.name)"
                self.ageLabel.text = "Age: \(profile.age)"
                self.genderLabel.text = "Gender: \(profile.gender.rawValue)"
                self.hobbiesLabel.text = "Hobbies: \(profile.hobbiesDescription)"
                self.profileImageLabel.text = "Profile Image: \(profile.image)"
            }
        }
    }
    
    // In a real application, I would use something more robust than expecting a comma separated list (i.e. UITableView)
    @IBAction func editHobbies(_ sender: Any) {
        guard let profile = profile else {
            return
        }
        
        let alert = UIAlertController(title: "Update Hobbies", message: "Separate each hobby with a comma.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "i.e Hiking,Camping,Cooking"
            textField.text = profile.hobbies.joined(separator: ",")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self] _ in
            let hobbiesTextField = alert.textFields![0] as UITextField
            let hobbies = hobbiesTextField.text ?? ""
            if !hobbies.isEmpty {
                self.db.collection("profiles").document(profile.id).setData([ "hobbies": hobbies.components(separatedBy: ",") ], merge: true)
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
        guard let profile = profile else {
            return
        }
        
        listener?.remove()
        let alert = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete this profile?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete Profile", style: .destructive, handler: { [unowned self] _ in
            self.db.collection("profiles").document(profile.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    // If something went wrong, add our listener back
                    self.addListener()
                } else {
                    print("Document successfully removed!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
    }
    
    fileprivate func addListener() {
        listener = db.collection("profiles").document(profileId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard let doc = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let profile = Profile(docId: doc.documentID, dict: doc.data()!)
                strongSelf.profile = profile
        }
    }

}
