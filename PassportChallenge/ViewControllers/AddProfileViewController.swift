//
//  AddProfileViewController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddProfileViewController: UIViewController {

    static let identifier = "addProfileViewController"
    fileprivate let maleImage = "https://firebasestorage.googleapis.com/v0/b/passportchallenge-f62af.appspot.com/o/profile_male.png?alt=media&token=ecbde5a4-c11d-42ad-93b9-1443a8cd6762"
    fileprivate let femaleImage = "https://firebasestorage.googleapis.com/v0/b/passportchallenge-f62af.appspot.com/o/profile_female.png?alt=media&token=5a8b7abc-bdf1-4870-a281-cd8869e085a6"
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    // Quick way to ensure user can see all of the fields
    // Would implement this differently with more time
    @IBOutlet var keyboardContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var ageTextField: UITextField!
    @IBOutlet private var genderSwitch: UISwitch!
    @IBOutlet private var hobbiesTextField: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createProfile(_ sender: Any) {
        guard let name = nameTextField.text,
              let age = ageTextField.text,
              let hobbies = hobbiesTextField.text else {
                return
        }
        
        if name.isEmpty || age.isEmpty || hobbies.isEmpty {
            let alert = UIAlertController(title: "Missing Fields", message: "Enter all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let gender = genderSwitch.isOn ? Gender.male : Gender.female
        let hobbiesArray = hobbies.components(separatedBy: ",")
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("profiles").addDocument(data: [
            "name": name,
            "age": Int(age)!,
            "gender": gender.rawValue,
            "hobbies": hobbiesArray,
            "image": gender == .male ? maleImage : femaleImage
        ]) { [weak self] err in
            guard let strongSelf = self else {
                return
            }
            
            if let err = err {
                print("Error adding document: \(err)")
                // todo: present alert
            } else {
                print("Document added with ID: \(ref!.documentID)")
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        // Quick way to ensure we will be able to see all of the content on the form
        // Essentially setting the height of an empty view equal to the keyboard height
        let userInfo = notification.userInfo!
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let constraintConstant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        keyboardContainerHeightConstraint.constant = constraintConstant
        self.view.layoutIfNeeded()
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
    }
    
}


