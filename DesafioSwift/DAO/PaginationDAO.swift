//
//  PaginationDAO.swift
//  DesafioSwift
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

enum State: Int {
    case new = 1
    case existent
}

class PaginationDAO: ParentDAO {
    
    init() {
        super.init(entity: "Pagination")
    }
    
    func getThePagination() -> (Pagination, State)  {
        let managedPaginations: [Pagination] = get(objectsWithPredicate: nil) as! [Pagination]
        
        if managedPaginations.count > 0 {
            return (managedPaginations[0], State.existent)
        }
        
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName:"Pagination", in: managedContext)!
        
        let pag: Pagination = Pagination(entity: entity, insertInto: managedContext)
        
        pag.lastId = ""
        
        save()
        
        return (pag, State.new)
    }
}
