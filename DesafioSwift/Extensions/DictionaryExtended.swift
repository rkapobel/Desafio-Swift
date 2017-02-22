//
//  DictionaryExtended.swift
//  DesafioSwift
//
//  Created by The App Master on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

extension Dictionary {
    func convertToDictionary(text: String) -> Dictionary<Key, Value>? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<Key, Value>
            } catch {
                print("error creating dictionary from JSON Value \(error.localizedDescription)")
            }
        }
        return nil
    }
}
