//
//  SearchResult.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation

//Search Result Object for API result
struct SearchResult: Decodable {
    let results: [Movies]?
}
