//
//  RedditManaged.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

extension Reddit {

    func update(withDict dict: [String: Any]) {
        
        self.id = dict["id"] as? String
        self.author = dict["author"] as? String
        self.title = dict["title"] as? String
        self.subredditNamePrefixed = dict["subreddit_name_prefixed"] as? String
        self.thumbnailSource = dict["thumbnail"] as? String
        self.createdUtc = dict["created_utc"] as! Double
        self.numComments = dict["num_comments"] as! Int32
        
        RedditDAO().save()
    }
}
