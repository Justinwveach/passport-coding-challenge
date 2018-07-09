//
//  FilterViewController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    static let identifier = "filterViewController"
    weak var delegate: Filter?
    var filters = Set<ProfileFilter>(arrayLiteral: .male, .female)

    @IBOutlet private var maleSwitch: UISwitch!
    @IBOutlet private var femaleSwitch: UISwitch!
    @IBOutlet private var over30Switch: UISwitch!
    
    @IBAction func done(_ sender: Any) {
        delegate?.filtered(filters)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        filters = Set<ProfileFilter>(arrayLiteral: .male, .female)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        maleSwitch.addTarget(self, action: #selector(handleSwitch(sender:)), for: .valueChanged)
        femaleSwitch.addTarget(self, action: #selector(handleSwitch(sender:)), for: .valueChanged)
        over30Switch.addTarget(self, action: #selector(handleSwitch(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        updateUI()
    }

    @objc fileprivate func handleSwitch(sender: UISwitch) {
        if sender === maleSwitch {
            handle(filter: .male, active: sender.isOn)
        }
        else if sender === femaleSwitch {
            handle(filter: .female, active: sender.isOn)
        }
        else if sender === over30Switch {
            handle(filter: .over30, active: sender.isOn)
        }
    }
    
    fileprivate func handle(filter: ProfileFilter, active: Bool) {
        if active {
            filters.insert(filter)
        } else {
            filters.remove(filter)
        }
    }
    
    fileprivate func reset(animated: Bool) {
        femaleSwitch.setOn(false, animated: animated)
        maleSwitch.setOn(false, animated: animated)
        over30Switch.setOn(false, animated: animated)
    }
    
    fileprivate func updateUI() {
        reset(animated: false)
        for filter in filters {
            switch filter {
            case .female:
                femaleSwitch.setOn(true, animated: true)
            case .male:
                maleSwitch.setOn(true, animated: true)
            case .over30:
                over30Switch.setOn(true, animated: true)
            }
        }
    }

}
