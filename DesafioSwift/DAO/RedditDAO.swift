//
//  RedditDAO.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class RedditDAO: ParentDAO {
    
    init() {
        super.init(entity: "Reddit")
    }
    
    func insert(withDict dict: [String: Any]) {
        
        let strId: String = dict["id"] as! String
        
        let managedReddits: [Reddit] = get(objectsWithPredicate:"id = %@", values: strId) as! [Reddit]
        
        if managedReddits.count > 0 {
            
            let redditManaged: NSManagedObject = managedReddits[0]
            
            completeValues(dict: dict, redditManaged: redditManaged as! Reddit)
            
            save()
            
            return
        }
        
        insert(insertValuesCompletion: { (redditManaged) in
            
            completeValues(dict: dict, redditManaged: redditManaged as! Reddit)
            
        })
    }
    
    func getAllById() -> [String: Reddit] {
        let allStoredReddits: [Reddit] = get(objectsWithPredicate: nil) as! [Reddit]
        
        var objectsById: [String: Reddit] = [String: Reddit]()
        
        for object in allStoredReddits {
            objectsById[object.id!] = object
        }
        
        return objectsById
    }
    
    func get(byId id: String) -> Reddit? {
        let reddits: [Reddit] = get(objectsWithPredicate: "id = %@", values: id) as! [Reddit]
        
        if reddits.count > 0 {
            return reddits[0]
        }
        
        return nil
    }
    
    func exists(objectWithId id: String) -> Bool {
        var exists: Bool! = false
        
        if get(objectsWithPredicate:"id = %@", values:id).count > 0 {
            exists = true
        }
        
        return exists
    }
    
    func getNewReddit() -> Reddit {
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName:"Reddit", in: managedContext)!
        
        let reddit: Reddit = Reddit(entity: entity, insertInto: managedContext)
        
        return reddit
    }
    
    func completeValues(dict: [String: Any], redditManaged: Reddit) {
        redditManaged.update(withDict: dict)
    }
}
