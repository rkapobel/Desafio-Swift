//
//  ParentDAO.swift
//  DesafioSwift
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class ParentDAO: NSObject {
    
    var managedContext: NSManagedObjectContext!
    var entityName: String!
        
    init(entity: String) {
        super.init()
        entityName = entity
        getContext()
    }
    
    func getContext() {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
        
    func insert(insertValuesCompletion block: (NSManagedObject) -> Void) {
        let entity =  NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        block(managedObject)
        
        save()
    }
    
    func get(objectsWithPredicate predicate: String?, values: String ... ) -> [NSManagedObject] {
        
        if let x:String = predicate {
            guard values.count == x.countInstances(of: "%@", "%ld", "%d", "%f") else {
                NSLog("condition for predicate was not fulfilled: number of values != #('%@')")
                return []
            }
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let letPredicate = predicate {
            fetchRequest.predicate = NSPredicate(format: letPredicate, argumentArray: values)
        }
        
        var objects: [NSManagedObject] = []
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            objects = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return objects
    }
    
    func delete(object: NSManagedObject) {
        managedContext.delete(object)
        
        save()
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
