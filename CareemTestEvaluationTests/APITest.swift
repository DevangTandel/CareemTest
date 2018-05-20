//
//  APITest.swift
//  CareemTestEvaluationTests
//
//  Created by Silver Shark on 20/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import XCTest

@testable import CareemTestEvaluation

class CareemAPITestEvaluationTests: XCTestCase {
    
    var webCollection : WebserviceCollections!
    var testUrl = "http://api.themoviedb.org/3/search/movie"
    
    override func setUp() {
        super.setUp()
        webCollection = WebserviceCollections()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            testSuccessResult()
        }
    }
    
    //Test Successfull Result from Server
    func testSuccessResult(){
        
        webCollection = WebserviceCollections()
        let param : [String : String] = ["api_key" : API_KEY,
                                      "query" : "Hulk",
                                      "page" : "1"]
        
        webCollection.serachMovies(param: param) {result in
            switch result {
            case .success(let movieResult):
                guard let movieResults = movieResult?.results else { return }
                
                //Assert return numbers of movies result
                XCTAssertEqual(movieResults.count, 20)
            case .failure(let error):
                XCTAssertEqual(error, .responseUnsuccessful )
            }
        }
    }
    
    //Test Invalid API Key
    func testInvalidToken(){
        
        webCollection = WebserviceCollections()
        let param : [String : String] = ["api_key" : "2696829a81b1b5827d515ff12170",
                                         "query" : "Hulk",
                                         "page" : "1"]
        
        webCollection.serachMovies(param: param) {result in
            switch result {
            case .success(let movieResult):
                guard let movieResults = movieResult?.results else {return}
                //Assert return numbers of movies in result
                XCTAssertEqual(movieResults.count, 0)
            case .failure(let error):
                //Assert return WebError
                XCTAssertEqual(error,.invalidAPIKey )
            }
        }
    }
    
    //Test WebservicePrefix class for URL creation
    func testCreateURL(){
        let url = WebServicePrefix.GetWSUrl(.searchMovies)
        //Assert return url to retrive movie list
        XCTAssertEqual(url,testUrl )
    }
}
