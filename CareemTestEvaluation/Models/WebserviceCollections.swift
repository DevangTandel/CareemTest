//
//  WebserviceCollections.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation

class WebserviceCollections: HttpRequestManager {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //In the signature of the function in the success case we define the Class type thats is the generic one in the API
    func serachMovies(param: [String : String], completion: @escaping (Result<SearchResult?, WebError>) -> Void) {
        
        let endpoint = WebServicePrefix.GetWSUrl(.searchMovies)
        let urlComponents = NSURLComponents(string: endpoint)!
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in param {
            let queryItem = URLQueryItem(name: key, value: value)
            urlComponents.queryItems!.append(queryItem)
        }
        let urlRequest = URLRequest(url: urlComponents.url!)
        fetch(with: urlRequest, decode: { json -> SearchResult? in
            guard let movieResult = json as? SearchResult else { return  nil }
            return movieResult
        }, completion: completion)
    }
}
