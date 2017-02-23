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

    func updateReddits(_ finishedBlock: @escaping ([NSManagedObject]?) -> Void) {
        
        // MARK: Este servicio es paginado pero por requerimiento solo muestro los primeros 25 reddits.
        
        Alamofire.request(Constants.RedditService.appending("?count=\(Constants.redditsCount)")).responseJSON { response in

            if let JSONData = response.data {

                let dict: [String: Any]? = Dictionary().convertToDictionary(fromData: JSONData)
                
                var allRedditsById: [String: NSManagedObject] = RedditDAO().getAllById()
                
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
                                            
                                            let managedObject: NSManagedObject? = allRedditsById.removeValue(forKey: idStr)
                                            
                                            if let letManagedObject = managedObject {
                                                let redditManaged: RedditManaged = RedditManaged(withManagedObject: letManagedObject)
                                                redditManaged.update(withDict: letDictOfValues)
                                            }else {
                                                RedditDAO().save(withDict: letDictOfValues)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: los reddits restantes deben ser eliminados junto con sus imagenes.
                
//                for (key, reddit) in allRedditsById {
//                    FileManager().deleteFile(withName: key, fromFolder: Constants.FilesFolder)
//                    RedditDAO().delete(reddit: reddit)
//                }
                
            }else {
                NSLog("service response error: %@", response.error?.localizedDescription ?? "error without description")
            }
            
            let arrayOfReddits: [NSManagedObject] = RedditDAO().get(redditsWithPredicate: nil)
            
            finishedBlock(arrayOfReddits)
        }
        
    }
}
