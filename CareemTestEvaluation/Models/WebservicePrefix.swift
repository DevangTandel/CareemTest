//
//  WebservicePrefix.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation

public enum WSRequestType : Int {
    case searchMovies
}

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

//MARK: - API ERRORS
//Probable API error that could have encounter while fetching results
enum WebError: Error {
    case requestFailed
    case invalidData
    case jsonConversionFailed
    case responseUnsuccessful
    case jsonParsingFailure
    case invalidAPIKey
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Sorry, Request is Failed. Please try again"
        case .invalidData:
            return "Sorry,Invalid Data"
        case .responseUnsuccessful:
            return "Sorry, Unable to get result from server"
        case .jsonParsingFailure:
            return "Sorry, Failed to parse response, We are working on it"
        case .jsonConversionFailed:
            return "Sorry, Failed to convert response, we will fixing the issue"
        case .invalidAPIKey:
            return "The API is key is Invalid"
        }
    }
}

//MARK: - STUCT FOR URL 
struct WebServicePrefix {
    static func GetWSUrl(_ serviceType :WSRequestType) -> String {
        var serviceURl: String?
        switch serviceType {
        case .searchMovies:
            serviceURl = "search/movie"
            break
        }
        return "\(BASE_URL)\(API_PATH)\(serviceURl!)" 
    }
}
