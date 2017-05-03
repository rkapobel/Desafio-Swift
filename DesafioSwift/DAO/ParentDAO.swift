//
//  ParentDAO.swift
//  DesafioSwift
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class ParentDAO: NSObject {
    
    var managedContext: NSManagedObjectContext!
    var entityName: String!
    
    /**
     Obtiene el contexto NSManagedObjectContext) del delegado y almacena la entidad que extiende de ParentDAO.
     */
    init(entity: String) {
        super.init()
        entityName = entity
        getContext()
    }
    
    /**
     Obtiene el contexto (NSManagedObjectContext) del delegado.
     */
    func getContext() {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    /**
     Crea una entidad nueva y mediante la funcion block ingresada por parametro se le pide a la subclase que complete sus parametros.
     */
    func insert(insertValuesCompletion block: (NSManagedObject) -> Void) {
        let entity =  NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        block(managedObject)
        
        save()
    }
    
    /**
     Obtiene los reddits segun un predicado ingresado y sus valores. 
     
     La cantidad de espeficiadores de formato de predicate tiene que ser igual a la cantidad de valores en values o el resultado será un arreglo vacío.
     
     Puede indicarse un atributo por el cual ordenar el resultado y si se desea hacerlo de manera ascendente mendiante attr y ASC respectivamente.
     */
    func get(objectsWithPredicate predicate: String?, values: String ..., sortBy attr: String?, ASC: Bool?) -> [NSManagedObject] {
        
        if let x:String = predicate {
            guard values.count == x.countInstances(of: "%@", "%ld", "%d", "%f") else {
                NSLog("condition for predicate was not fulfilled: number of values != #('%@')")
                return []
            }
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let letPredicate = predicate {
            fetchRequest.predicate = NSPredicate(format: letPredicate, argumentArray: values)
        }
        
        if let letAttr = attr, let letASC = ASC {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: letAttr, ascending: letASC)]
        }
        
        var objects: [NSManagedObject] = []
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            objects = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return objects
    }
    
    /**
     Obtiene los reddits segun un predicado ingresado y sus valores.
     
     La cantidad de espeficiadores de formato de predicate tiene que ser igual a la cantidad de valores en values o el resultado será un arreglo vacío.
     */
    func get(objectsWithPredicate predicate: String?, values: Any ...) -> [NSManagedObject] {
        
        if let x:String = predicate {
            guard values.count == x.countInstances(of: "%@", "%ld", "%d", "%f") else {
                NSLog("condition for predicate was not fulfilled: number of values != #('%@')")
                return []
            }
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let letPredicate = predicate {
            fetchRequest.predicate = NSPredicate(format: letPredicate, argumentArray: values)
        }
        
        var objects: [NSManagedObject] = []
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            objects = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return objects
    }
    
    /**
     Como su nombre lo indica, ingresando un NSManagedObject lo elimina de la base de datos.
    */
    func delete(object: NSManagedObject) {
        managedContext.delete(object)
        
        save()
    }
    
    /**
     Como su nombre lo indica, persiste los datos en la base de datos.
     */
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
