//
//  StringExtended.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 22/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

extension String {
    func countInstances(of stringsToFind: String ...) -> Int {
        var stringToSearch = self
        var count = 0
        
        for string in stringsToFind {
            repeat {
                guard let foundRange = stringToSearch.range(of: string, options: .diacriticInsensitive)
                    else { break }
                stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
                count += 1
                
            } while (true)
        }
        
        return count
    }
}
