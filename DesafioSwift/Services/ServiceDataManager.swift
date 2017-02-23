//
//  ServiceDataManager.swift
//  DesafioSwift
//
//  Created by The App Master on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

// MARK: Este servicio es paginado pero por requerimiento solo muestro los primeros 25 reddits.

class ServiceDataManager: NSObject {

    /**
     Esta funcion llama al servicio de reddits haciendo uso de una entidad Pagination que se envia en la firma a través de pag.
     
     La función finishedBlock devuelve un arreglo con Reddits
    */
    func updateReddits(_ finishedBlock: @escaping ([Reddit]?) -> Void, pag: Pagination) {
    
        var withAfter: String = ""
        
        if (pag.lastId?.characters.count)! > 0 {
            withAfter = "&after=t3_\(pag.lastId)"
        }
    
        callUpdate(finishedBlock, withUrl: Constants.RedditService.appending("?count=\(Constants.redditsCount)\(withAfter)"))
    }
    
    /**
     Esta funcion llama al servicio de reddits sin hacer uso de paginación.
     
     La función finishedBlock devuelve un arreglo con Reddits
     */
    func updateReddits (_ finishedBlock: @escaping ([Reddit]?) -> Void) {
        callUpdate(finishedBlock, withUrl: Constants.RedditService.appending("?count=\(Constants.redditsCount)"))
    }
    
    /**
     Esta funcion llama al servicio de reddits con una url que apunta al servicio deseado.
     
     La función finishedBlock devuelve un arreglo con Reddits
     */
    func callUpdate(_ finishedBlock: @escaping ([Reddit]?) -> Void, withUrl url: String) {
        Alamofire.request(url).responseJSON { response in
            
            if let JSONData = response.data {
                
                if response.error != nil {
                    NSLog("service response error: %@", response.error?.localizedDescription ?? "error without description")
                    
                    let alert: UIAlertController = UIAlertController()
                    alert.title = "Reddit Update Error"
                    // MARK: Los textos son en diferentes idiomas por ahora. Puede detectarse el tipo de error usando el atributo code.
                    alert.message = "\(response.error?.localizedDescription ?? "some service error"): \n Los datos que vea pueden estar desactualizados"
                    
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
                    alert.addAction(defaultAction);
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    let arrayOfReddits: [Reddit] = RedditDAO().get(objectsWithPredicate: nil, sortBy: "score", ASC: false) as! [Reddit]
                    
                    finishedBlock(arrayOfReddits)
                    
                    return
                }
                
                let dict: [String: Any]? = Dictionary().convertToDictionary(fromData: JSONData)
                
                var allRedditsById: [String: Reddit] = RedditDAO().getAllById()
                
                if let letDict = dict {
                    
                    let dictDataOne: [String: Any]? = letDict["data"] as? [String: Any]
                    
                    if let letDictDataOne = dictDataOne {
                        
                        let arrChildrens = letDictDataOne["children"]
                        
                        if let letArrChildrens = arrChildrens {
                            
                            for child in letArrChildrens as! [[String: Any]] {
                                
                                for (key, value) in child {
                                    if key == "data" {
                                        let dictOfValues = value as? [String: Any]
                                        
                                        if let letDictOfValues = dictOfValues {
                                            
                                            let idStr = letDictOfValues["id"] as! String
                                            
                                            let managedReddit: Reddit? = allRedditsById.removeValue(forKey: idStr)
                                            
                                            if let letManagedReddit = managedReddit {
                                                letManagedReddit.update(withDict: letDictOfValues)
                                            }else {
                                                RedditDAO().insert(withDict: letDictOfValues)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
// MARK: los reddits restantes deben ser eliminados junto con sus imagenes.
                
                for (key, reddit) in allRedditsById {
                    FileManager().deleteFile(withName: key, fromFolder: Constants.FilesFolder)
                    RedditDAO().delete(object: reddit)
                }
                
            }else {
                NSLog("service response error: %@", response.error?.localizedDescription ?? "error without description")
            }
            
            let arrayOfReddits: [Reddit] = RedditDAO().get(objectsWithPredicate: nil, sortBy: "score", ASC: false) as! [Reddit]
            
            finishedBlock(arrayOfReddits)
        }
    }
}
