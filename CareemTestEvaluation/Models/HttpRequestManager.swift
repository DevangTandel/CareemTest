//
//  HttpRequestManager.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation

protocol HttpRequestManager {
    
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, WebError>) -> Void)
}


extension HttpRequestManager {
    
    typealias JSONTaskCompletionHandler = (Decodable?, WebError?) -> Void
    func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch let error {
                        print(error)
                        completion(nil, .jsonConversionFailed)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            }else if httpResponse.statusCode == 401 {
                completion(nil, .invalidAPIKey)
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, WebError>) -> Void) {
        
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            //Change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
