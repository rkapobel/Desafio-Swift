//
//  NSDateExtended.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

extension NSDate {
    func getDateStringFrom(utc: Float) -> String! {
        let date = NSDate(timeIntervalSince1970: TimeInterval(utc))
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "dd/MM/YYYY - HH:mm"
        return dateFormatter.string(from: date as Date)
    }
}
