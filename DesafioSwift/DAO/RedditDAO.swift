//
//  RedditDAO.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

/**
 La entidad Reddit y el manager RedditDAO estan pensados para controlar la consitencia total de los datos.
 Cada Reddit tiene un id y dado que CoreData no dispone del concepto de PRIMARY KEY´s el manejo de duplicados se hace externamente.
 los valores id de Reddit están indexados.
 */

class RedditDAO: ParentDAO {
    
    /**
     Gran parte de la funcionalidad del DAO estan en el Parent, por lo tanto el mismo necesita saber quien es la entidad para crear objetos representables.
     */
    init() {
        super.init(entity: String(describing: Reddit.self))
    }
    
    /**
     Ingresando el diccionario con los atributos de un Reddit se puede lograr un insert adecuado.
    */
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
    
    /**
     Devuelve un diccionario de todos los reddits por id.
     */
    func getAllById() -> [String: Reddit] {
        let allStoredReddits: [Reddit] = get(objectsWithPredicate: nil) as! [Reddit]
        
        var objectsById: [String: Reddit] = [String: Reddit]()
        
        for object in allStoredReddits {
            objectsById[object.id!] = object
        }
        
        return objectsById
    }
    
    /**
     Devuelve un Reddit existente para el id ingresado o nil si no hay coincidencia.
     */
    func get(byId id: String) -> Reddit? {
        let reddits: [Reddit] = get(objectsWithPredicate: "id = %@", values: id) as! [Reddit]
        
        if reddits.count > 0 {
            return reddits[0]
        }
        
        return nil
    }
    
    /**
     Devuelve true si hay coincidencia o false en otro caso.
     */
    func exists(objectWithId id: String) -> Bool {
        var exists: Bool! = false
        
        if get(objectsWithPredicate:"id = %@", values:id).count > 0 {
            exists = true
        }
        
        return exists
    }
    
    /**
     Crea un reddit y lo inserta en la entidad. Debe hacerse save() manualmente para lograr la persistencia de los datos, de otra manera la misma no esta asegurada.
     */
    func getNewReddit() -> Reddit {
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName:String(describing: Reddit.self), in: managedContext)!
        
        let reddit: Reddit = Reddit(entity: entity, insertInto: managedContext)
        
        return reddit
    }
    
    /**
     La extensión de Reddit en RedditExtended tiene la función update que dado un diccionario con sus atributos, los actualiza en la entidad.
    */
    func completeValues(dict: [String: Any], redditManaged: Reddit) {
        redditManaged.update(withDict: dict)
    }
}
