//
//  Reddit.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

class Reddit: NSObject {
    var id: String!
    var title: String!
    var author: String!
    var createdUtc: Float!
    var numComments: NSInteger!
    var subredditNamePrefixed: String!
    var thumbnailSource: String!
    
    override init() {
        super.init()
        id = ""
        title = ""
        author = ""
        createdUtc = 0
        numComments = 0
        subredditNamePrefixed = ""
        thumbnailSource = ""
    }
}
