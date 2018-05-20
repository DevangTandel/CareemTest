//
//  DTDatabaseManager.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 17/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager{
    
    static let sharedDatabase = DatabaseManager()
    
    // METHODS
    private init() {}
    
    struct once {
        static var onceToken: Int = 0
    }
    
    
    //MARK: Sort Array
    class func sortby(_ attribute: String, array: NSArray) -> NSArray {
        let sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: attribute, ascending: true)
        let arr : NSArray = array.sortedArray(using: [sortDescriptor]) as NSArray
        return arr
    }
    
    //MARK: SELECT QUERY
    
    class func select(_ entity: String, members member: NSArray, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> NSArray {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = member as [AnyObject]
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results
        }catch{
            return []
        }
    }
    
    //MARK: SELECT ALL QUERY
    
    func selectAll(_ entity: String, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> NSArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results
        }catch{
            return []
        }
    }
    
    func select(_ entity: String, members member: NSArray, withpredicate predicate: NSPredicate, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> NSArray {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = member as [AnyObject]
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results
        }catch{
            return []
        }
    }
    
    func select(_ entity: String, withpredicate predicate: NSPredicate, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> NSArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results
        }
        catch{
            return []
        }
    }
    
    
    func select(_ entity: String, withpredicate predicate: NSPredicate, priorityDict sortDic: NSArray, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> NSArray {
        let sortDescriptors: NSArray =  sortDic
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results.sortedArray(using: sortDescriptors as! [NSSortDescriptor]) as NSArray
        }
        catch{
            return []
        }
    }

    
    func selectSingle(_ entity: String, withpredicate predicate: String, fromObjectContext ManagedObjectContext: NSManagedObjectContext) -> AnyObject? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(format: predicate)
        fetchRequest.fetchLimit = 1
        
        do{
            let results: NSArray = try ManagedObjectContext.fetch(fetchRequest) as NSArray
            return results.lastObject! as AnyObject
        }
        catch{
            return nil
        }
    }
    
    class func writeErrorLogsToFile(_ strErr: String) {
        
        // Build the path, and create if needed.
        let filePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName: String = DatabaseManager.sharedDatabase.errorLogFile
        let fileAtPath: String = filePath.appending(fileName)
        if !FileManager.default.fileExists(atPath: fileAtPath) {
            FileManager.default.createFile(atPath: fileAtPath, contents: nil, attributes: nil)
        }
        var strLog:String!
        var strFileData:String = ""
        
        do {
            strFileData  = try NSString(contentsOfFile: fileAtPath, usedEncoding: nil) as String
        } catch {
            // contents could not be loaded
        }
        if strFileData.count > 0 {
            strLog = "\n\(strErr)"
        }
        else {
            strLog = strErr
        }
        // The main act...
        let handle: FileHandle = FileHandle.init(forWritingAtPath: fileAtPath)!
        handle.truncateFile(atOffset: handle.seekToEndOfFile())
        handle.write(strLog.data(using: String.Encoding.utf8)!)
    }
    
    class func readErrorFile() -> String {
        // Build the path...
        let filePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName: String = DatabaseManager.sharedDatabase.errorLogFile
        let fileAtPath: String = filePath.appending(fileName)
        // The main act...
        let strFileData:String!
        do {
            strFileData  = try NSString(contentsOfFile: fileAtPath, usedEncoding: nil) as String
        } catch {
            strFileData = ""
        }
        return strFileData
    }
    
    var syncDatabase: DatabaseManager? = nil
    var errorLogFile: String = "CreemTest_ErrorLogs.txt"
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CareemTestEvaluation", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CareemTestEvaluation.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext ()->Bool {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        }
        return false
    }
    
    
    // MARK: - Save Search to core DB
    func saveSearch(_ serachQuery: String) -> String {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENITYTSEARCH)
        fetchRequest.predicate = NSPredicate(format:"searchQuery == %@",argumentArray:[serachQuery])
        do{
            let arrSearch = try DatabaseManager.sharedDatabase.managedObjectContext.fetch(fetchRequest)
            if arrSearch.count > 0 {
                for object in arrSearch {
                    DatabaseManager.sharedDatabase.managedObjectContext.delete(object as! NSManagedObject)
                    print(DatabaseManager.sharedDatabase.saveContext())
                }
            }
            let entity =
                NSEntityDescription.entity(forEntityName: ENITYTSEARCH,
                                           in: DatabaseManager.sharedDatabase.managedObjectContext)!
            let search = NSManagedObject(entity: entity,
                                         insertInto: DatabaseManager.sharedDatabase.managedObjectContext)
            search.setValue(serachQuery, forKeyPath: "searchQuery")
            regulateNumberOfEntries()
        }
        catch{
            print("An error occured while fetching Airport")
        }
        if !DatabaseManager.sharedDatabase.saveContext(){
            DatabaseManager.writeErrorLogsToFile("LOG: \(Date())\t METHOD: \("checkNotificationDataForDict"):\(#line) \t ERROR: \("")")
        }
        return serachQuery
    }
    
    func getAllSearchResult( _ searchQuery : String ) -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENITYTSEARCH)
        if searchQuery.count != 0{
            fetchRequest.predicate = NSPredicate(format:"searchQuery contains[cd] %@",argumentArray:[searchQuery])
        }
        do {
            let arrSearch = try DatabaseManager.sharedDatabase.managedObjectContext.fetch(fetchRequest)
            var arrSearchQuery : [String] = [String]()
            for (_, object) in arrSearch.enumerated(){
                let obj : NSManagedObject = object as! NSManagedObject
                arrSearchQuery.append(obj.value(forKeyPath: "searchQuery") as! String)
            }
            return arrSearchQuery.reversed()
        }catch{
            return []
        }
    }
    
    func regulateNumberOfEntries(){
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENITYTSEARCH)
        do {
            let arrSearch = try DatabaseManager.sharedDatabase.managedObjectContext.fetch(fetchRequest)
            if arrSearch.count == 11 {
                DatabaseManager.sharedDatabase.managedObjectContext.delete(arrSearch.first as! NSManagedObject)
                print(DatabaseManager.sharedDatabase.saveContext())
            }
        }catch{
            print("Error")
        }
    }
}
