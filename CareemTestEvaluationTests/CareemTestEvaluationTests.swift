//
//  CareemTestEvaluationTests.swift
//  CareemTestEvaluationTests
//
//  Created by Silver Shark on 16/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import XCTest
import CoreData

@testable import CareemTestEvaluation

 var coreDataManager: DatabaseManager!

class CareemTestEvaluationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        coreDataManager = DatabaseManager.sharedDatabase
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /*This test case test for the proper initialization of CoreDataManager class :)*/
    func test_init_coreDataManager(){
        
        let instance = DatabaseManager.sharedDatabase
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( instance )
    }
    
    /*This test case test if NSPersistentContainer(the actual core data stack) initializes successfully or not. In case it fails in getting a proper instance It will generate a failure.
     */
    func test_coreDataStackInitialization() {
        let coreDataStack = DatabaseManager.sharedDatabase.persistentStoreCoordinator
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( coreDataStack )
    }
    
    /*This test case inserts a person record*/
    func test_create_SearchQuery() {
        
        //Given the search
        let search1 = "Thor"
        let search2 = "Hulk"
        let search3 = "Antman"
        
        let searchResult1 = coreDataManager.saveSearch(search1)
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( searchResult1 )
        
        let searchResult2 = coreDataManager.saveSearch(search2)
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( searchResult2 )
        
        let searchResult3 = coreDataManager.saveSearch(search3)
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( searchResult3 )
        
    }
    
    /*This test case fetches all person records*/
    func test_fetch_all_search() {
        
        //get search Query already saved
        let results = coreDataManager.getAllSearchResult("")
        
        //Assert return numbers of searchSaved
        //Asserts that two optional values are equal.
        XCTAssertEqual(results.count, 3)
        
        let results1 = coreDataManager.getAllSearchResult("Hulk")
        //Assert return numbers of searched Query wmatching "Bat"
        XCTAssertEqual(results1.count, 1)
        
        let results2 = coreDataManager.getAllSearchResult("Devang")
        XCTAssertEqual(results2.count, 0)
    }
    

    
}
