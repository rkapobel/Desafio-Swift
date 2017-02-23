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

class ServiceDataManager: NSObject {

    func updateReddits(_ finishedBlock: @escaping ([Reddit]?) -> Void, pag: Pagination) {
        
        // MARK: Esta implementacion de CoreData no tiene relationships, fetch properties, trabajos de concurrencia y casi ninguna otra funcionalidad especial de CoreData. Solo el campo id en Reddit esta indexado.
        
        // MARK: Este servicio es paginado pero por requerimiento solo muestro los primeros 25 reddits.
    
        var withAfter: String = ""
        
        if (pag.lastId?.characters.count)! > 0 {
            withAfter = "&after=t3_\(pag.lastId)"
        }
    
        callUpdate(finishedBlock, withUrl: Constants.RedditService.appending("?count=\(Constants.redditsCount)\(withAfter)"))
    }
    
    func updateReddits (_ finishedBlock: @escaping ([Reddit]?) -> Void) {
        callUpdate(finishedBlock, withUrl: Constants.RedditService.appending("?count=\(Constants.redditsCount)"))
    }
    
    func callUpdate(_ finishedBlock: @escaping ([Reddit]?) -> Void, withUrl url: String) {
        Alamofire.request(url).responseJSON { response in
            
            if let JSONData = response.data {
                
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
            
            let arrayOfReddits: [Reddit] = RedditDAO().get(objectsWithPredicate: nil) as! [Reddit]
            
            finishedBlock(arrayOfReddits)
        }
    }
}
