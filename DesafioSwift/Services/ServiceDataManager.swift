//
//  ServiceDataManager.swift
//  DesafioSwift
//
//  Created by The App Master on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import Alamofire

class ServiceDataManager: NSObject {

    func updateReddits(_ finishedBlock: @escaping (Array<Reddit>?) -> Void) {
        
        Alamofire.request(Constants.Services.RedditService.rawValue).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.result)   // result of response serialization
//                print(response.data)     // server data
//
            if let JSON = response.result.value {
                //print("JSON: \(JSON)")
                
                let dict: Dictionary<String, Any>? = Dictionary<String, Any>().convertToDictionary(text: String(describing: JSON))
                
                print("Dictionary \(dict)")
            }
            
            // MARK: change to var to mutate
            let arrayOfReddits: Array<Reddit>? = nil
            
            finishedBlock(arrayOfReddits)
        }
        
    }
    
}
