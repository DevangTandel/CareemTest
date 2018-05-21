//
//  Movies.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation

/*Object Model Of Movies Result
 Swift 4 introduced Codable type that help us to get rid of Unneccessary tool to parse JSON object
 */
struct Movies : Decodable {
    let id: Int
    let vote_count: Int
    let video: Bool
    let vote_average: Float
    let title: String
    let popularity: Float
    let poster_path: String?
    let original_language:  String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String?
    let adult: Bool
    let overview: String
    let release_date: String
}
