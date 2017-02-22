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
    
    func save(withDict dict: [String: Any]) {
        
        let strId: String = dict["id"] as! String
    
        let managedReddits: [NSManagedObject] = get(redditsWithPredicate:"id = %@", values: strId)
        
        if managedReddits.count > 0 {
            
            let managedReddit: NSManagedObject = managedReddits[0]
            
            managedReddit.setValue(strId, forKey: "id")
            managedReddit.setValue(dict["author"] as! String, forKey: "author")
            managedReddit.setValue(dict["title"] as! String, forKey: "title")
            managedReddit.setValue(dict["subreddit_name_prefixed"] as! String, forKey: "subredditNamePrefixed")
            managedReddit.setValue(dict["thumbnail"] as! String, forKey: "thumbnailSource")
            managedReddit.setValue(dict["created_utc"] as! Double, forKey: "createdUtc")
            managedReddit.setValue(dict["num_comments"] as! Int32, forKey: "numComments")
            
            update()
            
            return
        }
        
        let entity =  NSEntityDescription.entity(forEntityName: "Reddit", in: managedContext)
        
        let redditManaged = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        redditManaged.setValue(dict["id"] as! String, forKey: "id")
        redditManaged.setValue(dict["author"] as! String, forKey: "author")
        redditManaged.setValue(dict["title"] as! String, forKey: "title")
        redditManaged.setValue(dict["subreddit_name_prefixed"] as! String, forKey: "subredditNamePrefixed")
        redditManaged.setValue(dict["thumbnail"] as! String, forKey: "thumbnailSource")
        redditManaged.setValue(dict["created_utc"] as! Double, forKey: "createdUtc")
        redditManaged.setValue(dict["num_comments"] as! Int32, forKey: "numComments")
    
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
    
    func getAllById() -> [String: NSManagedObject] {
        let allStoredReddits: [NSManagedObject] = get(redditsWithPredicate: nil)
        
        var redditsById: [String: NSManagedObject] = [String: NSManagedObject]()

        for reddit in allStoredReddits {
            redditsById[reddit.value(forKey: "id") as! String] = reddit
        }
        
        return redditsById
    }
    
    func redditExists(redditWithId id: String) -> Bool {
        var exists: Bool! = false
        
        if get(redditsWithPredicate:"id = %@", values:id).count > 0 {
           exists = true
        }
        
        return exists
    }
    
    func delete(reddit: NSManagedObject) {
        
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
