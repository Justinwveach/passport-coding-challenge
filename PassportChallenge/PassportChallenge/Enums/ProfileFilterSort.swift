//
//  ProfileFilterSor.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

enum ProfileFilter {
    case male
    case female
    case over30
}

enum ProfileSort: String {
    case defaultSort = "Default"
    case nameAscending = "Name Ascending"
    case nameDescending = "Name Descending"
    case ageAscending = "Age Ascending"
    case ageDescending = "Age Descending"
    
    // Swift 4.2 will include CaseIterable protocol to handle this for us
    static var allCases: [ProfileSort] = [.defaultSort, .nameAscending, .nameDescending, .ageAscending, .ageDescending]
}
