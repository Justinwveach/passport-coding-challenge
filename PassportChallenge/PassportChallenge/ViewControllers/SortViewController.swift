//
//  SortViewController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let identifier = "sortViewController"
    @IBOutlet private var sortTableView: UITableView!
    weak var delegate: Sort?
    var sortOptions = [ProfileSort]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sortTableView.delegate = self
        sortTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortOption = sortOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        cell.textLabel?.text = sortOption.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortOption = sortOptions[indexPath.row]
        delegate?.sorted(sortOption)
        navigationController?.popViewController(animated: true)
    }
    
}
