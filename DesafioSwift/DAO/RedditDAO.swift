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
    
    func save(reddit: Reddit) {
        
        let appDelegate =
            UIApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity =  NSEntityDescription.entity(forEntityName: "Reddit", in: managedContext)
        
        let redditManaged = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        redditManaged.setValue(reddit.id, forKey: "id")
        redditManaged.setValue(reddit.author, forKey: "author")
        redditManaged.setValue(reddit.title, forKey: "title")
        redditManaged.setValue(reddit.createdUtc, forKey: "createdUtc")
        redditManaged.setValue(reddit.numComments, forKey: "numComments")
        redditManaged.setValue(reddit.subredditNamePrefixed, forKey: "subredditNamePrefixed")
        redditManaged.setValue(reddit.thumbnailSource, forKey: "thumbnailSource")
    
        do {
            try managedContext.save()
            //5: create a dict
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func get(redditsWithPredicate predicate: String?, values: String ... ) -> [NSManagedObject] {
    
        if let x:String = predicate {
            guard values.count == x.countInstances(of: "%@") else {
                NSLog("condition for predicate was not fulfilled: number of values != #('%@')")
                return []
            }
        }
        
        let appDelegate =
            UIApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
    
    func delete(reddit: Reddit) {
        
        let appDelegate =
            UIApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext

        managedContext.delete(reddit)
    }
}
