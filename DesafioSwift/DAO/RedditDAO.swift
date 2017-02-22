//
//  RedditDAO.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class RedditDAO: NSObject {
    
    var managedContext: NSManagedObjectContext!

    override init() {
        super.init()
        getContext()
    }
    
    func getContext() {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func save(withId id: String,
              author: String,
              title: String,
              createdUtc: Double,
              numComments: UInt32,
              subredditNamePrefixed: String,
              thumbnailSource: String) {
    
        let managedReddits: [NSManagedObject] = get(redditsWithPredicate:"id = %@", values: id)
        
        if managedReddits.count > 0 {
            
            let managedReddit: NSManagedObject = managedReddits[0]
            
            managedReddit.setValue(id, forKey: "id")
            managedReddit.setValue(author, forKey: "author")
            managedReddit.setValue(title, forKey: "title")
            managedReddit.setValue(createdUtc, forKey: "createdUtc")
            managedReddit.setValue(numComments, forKey: "numComments")
            managedReddit.setValue(subredditNamePrefixed, forKey: "subredditNamePrefixed")
            managedReddit.setValue(thumbnailSource, forKey: "thumbnailSource")
            
            update()
            
            return
        }
        
        let entity =  NSEntityDescription.entity(forEntityName: "Reddit", in: managedContext)
        
        let redditManaged = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        redditManaged.setValue(id, forKey: "id")
        redditManaged.setValue(author, forKey: "author")
        redditManaged.setValue(title, forKey: "title")
        redditManaged.setValue(createdUtc, forKey: "createdUtc")
        redditManaged.setValue(numComments, forKey: "numComments")
        redditManaged.setValue(subredditNamePrefixed, forKey: "subredditNamePrefixed")
        redditManaged.setValue(thumbnailSource, forKey: "thumbnailSource")
    
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func get(redditsWithPredicate predicate: String?, values: String ... ) -> [NSManagedObject] {
        
        if let x:String = predicate {
            guard values.count == x.countInstances(of: "%@", "%ld", "%d", "%f") else {
                NSLog("condition for predicate was not fulfilled: number of values != #('%@')")
                return []
            }
        }
 
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reddit")
        
        if let letPredicate = predicate {
            fetchRequest.predicate = NSPredicate(format: letPredicate, argumentArray: values)
        }
        
        var reddits: [NSManagedObject] = []
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            reddits = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return reddits
    }
    
    func redditExists(redditWithId id: String) -> Bool {
        var exists: Bool! = false
        
        if get(redditsWithPredicate:"id = %@", values:id).count > 0 {
           exists = true
        }
        
        return exists
    }
    
    func delete(reddit: Reddit) {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext

        managedContext.delete(reddit)
    }
    
    func getNewReddit() -> Reddit {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName:"Reddit", in: managedContext)!
        
        let reddit: Reddit = Reddit(entity: entity, insertInto: managedContext)
        
        return reddit
    }
    
    func update() {
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
