//
//  ViewController.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/6/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfilesViewController: UIViewController {
    
    @IBOutlet private var profilesTableView: UITableView!

    var dataStore: ProfilesDataStore!
    var dataSource: ProfilesDataSource!
    var currentSort = ProfileSort.defaultSort
    var currentFilters = Set<ProfileFilter>(arrayLiteral: .male, .female)
    
    private lazy var filterViewController: FilterViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: FilterViewController.identifier) as! FilterViewController
        vc.delegate = self
        return vc
    }()
    
    private lazy var sortViewController: SortViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SortViewController.identifier) as! SortViewController
        vc.delegate = self
        vc.sortOptions = ProfileSort.allCases
        return vc
    }()
    
    @IBAction func filter(_ sender: Any) {
        navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    @IBAction func sort(_ sender: Any) {
        navigationController?.pushViewController(sortViewController, animated: true)
    }
    
    @IBAction func addProfile(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddProfileViewController.identifier) as! AddProfileViewController
        present(vc, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = ProfilesDataSource([Profile]())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilesTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        profilesTableView.rowHeight = UITableViewAutomaticDimension
        
        dataStore = ProfilesDataStore(delegate: self)
        profilesTableView.delegate = self
        profilesTableView.dataSource = dataSource
    }
    
    fileprivate func filter(_ gender: Gender) {
        let filteredProfiles = self.dataStore.profiles.filter({
            $0.gender == gender
        })
        self.dataSource.profiles = filteredProfiles
        self.profilesTableView.reloadData()
    }
    
    fileprivate func resetList() {
        dataSource.profiles = dataStore.profiles
        profilesTableView.reloadData()
    }

}

extension ProfilesViewController: StoreDelegate {
    
    func didUpdate(store: Store) {
        guard let _ = store as? ProfilesDataStore else {
            print("Unexpected store")
            return
        }
        print("Items updated")
        organizeData()
    }
    
}

extension ProfilesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = dataSource.profiles[indexPath.row]
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
        profileViewController.profileId = profile.id
        navigationController?.pushViewController(profileViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ProfilesViewController: Filter, Sort {
    
    func filtered<FilterType>(_ filters: Set<FilterType>) where FilterType : Hashable {
        guard let filters = filters as? Set<ProfileFilter> else {
            return
        }
        
        currentFilters = filters
        organizeData()
    }
    
    func sorted<SortType>(_ sortOption: SortType) {
        guard let sortOption = sortOption as? ProfileSort else {
            return
        }
        
        currentSort = sortOption
        organizeData()
    }
    
    fileprivate func organizeData() {
        let filteredProfiles = dataStore.filter(currentFilters)
        let sortedProfiles = filteredProfiles.sorted(by: { (lhs, rhs) in
            switch currentSort {
            case .defaultSort:
                return lhs.id < rhs.id
            case .nameAscending:
                return lhs.name < rhs.name
            case .nameDescending:
                return lhs.name > rhs.name
            case .ageAscending:
                return lhs.age < rhs.age
            case .ageDescending:
                return lhs.age > rhs.age
            }
        })
        self.dataSource.profiles = sortedProfiles
        self.profilesTableView.reloadData()
    }
}

