//
//  FilterSort.swift
//  PassportChallenge
//
//  Created by Justin Veach on 7/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

protocol Filter: class {

    func filtered<FilterType>(_ filters: Set<FilterType>)
    
}

protocol Sort: class {
    
    func sorted<SortType>(_ sortOption: SortType)
    
}
