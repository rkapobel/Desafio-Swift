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
        
        // MARK: este servicio es paginado pero por requerimiento solo muestro los primeros 25 reddits.
        
        Alamofire.request(Constants.RedditService.appending("?count=\(Constants.redditsCount)")).responseJSON { response in

            if let JSONData = response.data {

                let dict: [String: Any]? = Dictionary().convertToDictionary(fromData: JSONData)

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

                                            // MARK: 1: Reddit DAO se encarga de todo: insertar o actualizar
                                            RedditDAO().save(withId: letDictOfValues["id"] as! String,
                                                             author: letDictOfValues["author"] as! String,
                                                             title: letDictOfValues["title"] as! String,
                                                             createdUtc: letDictOfValues["created_utc"] as! Double,
                                                             numComments: UInt32(letDictOfValues["num_comments"] as! Int32),
                                                             subredditNamePrefixed: letDictOfValues["subreddit_name_prefixed"] as! String,
                                                             thumbnailSource: letDictOfValues["thumbnail"] as! String)
                                            
                                            // MARK: Podria agregarse una logica de eliminacion de reddits. Si un reddit fue eliminado del servidor, entonces ese reddit ya no tiene que estar publicado y debe eliminarse de la base de datos junto con el thumbnail si existiese.
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                NSLog("service response error: %@", response.error?.localizedDescription ?? "error without description")
            }
            
            let arrayOfReddits: [NSManagedObject] = RedditDAO().get(redditsWithPredicate: nil)
            
            finishedBlock(arrayOfReddits)
        }
        
    }
}
