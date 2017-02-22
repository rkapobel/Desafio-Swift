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
        
        Alamofire.request(Constants.Services.RedditService.rawValue).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.result)   // result of response serialization
//                print(response.data)     // server data
//
            if let JSONData = response.data {

                let dict: [String: Any]? = Dictionary().convertToDictionary(fromData: JSONData)
                
                //print("Dictionary \(dict)")
                
                // MARK: change to var to mutate
                let arrayOfReddits: [NSManagedObject]? = nil
                
                //var redditsManaged: [NSManagedObject] = RedditDAO().get(redditsWithPredicate:nil)
                
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
                                            NSLog("%@", letDictOfValues)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                finishedBlock(arrayOfReddits)
            }else {
                finishedBlock(nil)
            }
            

        }
        
    }
    
}
