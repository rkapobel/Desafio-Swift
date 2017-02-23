//
//  DictionaryExtended.swift
//  DesafioSwift
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

// MARK: Dado un argumento Data crea un diccionario [Key: Value] utilizando JSON serealization

extension Dictionary {
    
    /**
     Dado un argumento Data crea un diccionario [Key: Value] utilizando JSON serealization
     */
    func convertToDictionary(fromData data: Data) -> [Key: Value]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [Key: Value]
        } catch {
            print("error creating dictionary from JSON Value \(error.localizedDescription)")
        }
        
        return nil
    }
}
