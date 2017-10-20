//
//  ParentDAO.swift
//  Moutex
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 The App Master. All rights reserved.
//

import UIKit
import CoreData

// MARK: Estoy bastante seguro que se puede lograr mas abstracción en los DAO que heredan del ParentDAO usando Any para lograr transparencia referencial.

class ParentDAO: NSObject {
    
    var persistentContainer: NSPersistentContainer!
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
        
        persistentContainer = appDelegate.persistentContainer
    }
    
    /**
     Crea una entidad nueva y mediante la funcion block ingresada por parametro se le pide a la subclase que complete sus parametros.
     */
    func insert(insertValuesCompletion block: @escaping (NSManagedObjectID) -> Void) {
        persistentContainer.viewContext.performAndWait {
            let entity =  NSEntityDescription.entity(forEntityName: self.entityName, in: self.persistentContainer.viewContext)
            
            let managedObject = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext)
            
            block(managedObject.objectID)
        }
    }
    
    /**
     Obtiene los objetos segun un predicado ingresado y sus valores.
     
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
        
        // MARK: TODO: I´m not sure if this could be really a problem. I´m doing a perform and wait call, so, i´m passing
        // managed objects throught queues (background one to main one) but i can´t find if this has hidden problems with concurrency.
        
        var objects: [NSManagedObject] = []
        
        persistentContainer.viewContext.performAndWait {
            do {
                let results =
                    try self.persistentContainer.viewContext.fetch(fetchRequest)
                objects = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        return objects
    }
    
    /**
     Obtiene los objetos segun un predicado ingresado y sus valores.
     
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
        
        // MARK: TODO: I´m not sure if this could be really a problem. I´m doing a perform and wait call, so, i´m passing
        // managed objects throught queues (background one to main one) but i can´t find if this has hidden problems with concurrency.
        
        var objects: [NSManagedObject] = []
        
        persistentContainer.viewContext.performAndWait {
            do {
                let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
                objects.append(contentsOf: results as! [NSManagedObject])
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        return objects
    }
    
    /**
     Como su nombre lo indica, ingresando un NSManagedObject lo elimina de la base de datos.
     */
    func delete(managedObject: NSManagedObject) {
        persistentContainer.viewContext.performAndWait {
            self.persistentContainer.viewContext.delete(managedObject)
        }
    }
    
    /**
     Elimina todos los objetos del modelo
     */
    func deleteAll() {
        let objects: [NSManagedObject] = get(objectsWithPredicate: nil)
        
        for object in objects {
            delete(managedObject: object)
        }
    }
    
    /**
     Como su nombre lo indica, persiste los datos en la base de datos asincronicamente.
     */
    func asyncSave() {
        persistentContainer.viewContext.perform {
            self.save(context: self.persistentContainer.viewContext)
        }
    }
    
    /**
     Como su nombre lo indica, persiste los datos en la base de datos sincronicamente.
     */
    func syncSave() {
        persistentContainer.viewContext.performAndWait {
            self.save(context: self.persistentContainer.viewContext)
        }
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
