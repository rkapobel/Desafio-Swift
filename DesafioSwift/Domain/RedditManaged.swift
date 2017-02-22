//
//  RedditManaged.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class RedditManaged: NSObject {
    private var managedObject: NSManagedObject!
    private var thumbnailSourceValue: String?
    private var idValue: String?
    private var authorValue: String?
    private var titleValue: String?
    private var createdUtcValue: Double?
    private var subredditNamePrefixedValue: String?
    private var numCommentsValue: UInt32?
    
    init(withManagedObject mg: NSManagedObject) {
        super.init()
        managedObject = mg
    }
    
    func getId() -> String {
        if idValue == nil {
            idValue = managedObject.value(forKey:"id") as? String
        }
        return idValue!
    }
    
    func getAuthor() -> String {
        if authorValue == nil {
            authorValue = managedObject.value(forKey:"author") as? String
        }
        return authorValue!
    }
    
    func getTitle() -> String {
        if titleValue == nil {
            titleValue = managedObject.value(forKey:"title") as? String
        }
        return titleValue!
    }
    
    func getSubrreditNamePrefixed() -> String {
        if subredditNamePrefixedValue == nil {
            subredditNamePrefixedValue = managedObject.value(forKey:"subredditNamePrefixed") as? String
        }
        return subredditNamePrefixedValue!
    }
    
    func getThumbnailSource() -> String {
        if thumbnailSourceValue == nil {
            thumbnailSourceValue = managedObject.value(forKey:"thumbnailSource") as? String
        }
        return thumbnailSourceValue!
    }
    
    func getNumComments() -> UInt32 {
        if numCommentsValue == nil {
            numCommentsValue = managedObject.value(forKey:"numComments") as? UInt32
        }
        return numCommentsValue!
    }
    
    func getCreatedUtc() -> Double {
        if createdUtcValue == nil {
            createdUtcValue = managedObject.value(forKey:"createdUtc") as? Double
        }
        return createdUtcValue!
    }
}
