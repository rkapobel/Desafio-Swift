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


/**
 La entidad Pagination y el manager PaginationDAO estan pensados para controlar el paginado total del servicio.
 
 La idea es que se mantiene una única entrada en la entidad Pagination que es lastId que representa el valor que tiene que ir en el argumento after del servicio de reddits. 
 
 Dado que CoreData está pensado como persitente de objetos gran parte de las consistencias en la entidad tienen que hacerse externamente al framework
 */
class PaginationDAO: ParentDAO {
    
    init() {
        super.init(entity: String(describing: Pagination.self))
    }
    
    func getThePagination() -> (Pagination, State)  {
        let managedPaginations: [Pagination] = get(objectsWithPredicate: nil) as! [Pagination]
        
        if managedPaginations.count > 0 {
            return (managedPaginations[0], State.existent)
        }
        
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName:String(describing: Pagination.self), in: persistentContainer.viewContext)!
        
        let pag: Pagination = Pagination(entity: entity, insertInto: persistentContainer.viewContext)
        
        pag.lastId = ""
        
        self.syncSave()
        
        return (pag, State.new)
    }
}
