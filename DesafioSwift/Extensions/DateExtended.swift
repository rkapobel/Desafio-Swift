//
//  NSDateExtended.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

extension Date {
    func getDateString(fromUtc utc: Float) -> String! {
        let date = Date(timeIntervalSince1970: TimeInterval(utc))
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "dd/MM/YYYY - HH:mm"
        return dateFormatter.string(from: date as Date)
    }
    
    func getFriedlyTime(fromUtc utc: Float) -> String {
        
        let dateUtc: Date = Date(timeIntervalSince1970: TimeInterval(utc))
        
        var timeText: String = "Hace "
        
        let hoursSinceUtc: Double = Date().timeIntervalSince(dateUtc)
        
        let daysInMonthRng: NSRange = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date())
        
        let daysInMonth: Double = Double(daysInMonthRng.length)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        var daysInYear: Double = 0
        
        let yearStr: String = dateFormatter.string(from: dateUtc)
        
        let yearInt: Int = Int(yearStr)!
        
        if yearInt % 400 == 0  {
            daysInYear = 366;
        } // Leap Year
        else if yearInt % 100 == 0 {
            daysInYear = 365; // Non Leap Year
        }
        else if yearInt % 4 == 0 {
            daysInYear = 366; // Leap Year
        }
        else { // Non-Leap Year
            daysInYear = 365;
        }
        
        if hoursSinceUtc >= daysInYear*24.0 {
            if hoursSinceUtc < daysInYear*24*2.0 {
                timeText = timeText.appending("un año")
            }else {
                timeText =  timeText.appending("\(hoursSinceUtc/(daysInYear*24)) años")
            }
        }else if hoursSinceUtc >= daysInMonth*24.0 {
            if hoursSinceUtc < daysInMonth*24*2.0 {
                timeText =  timeText.appending("un mes")
            }else {
                timeText =  timeText.appending("\(hoursSinceUtc/(daysInYear*24)) meses")
            }
        }else if hoursSinceUtc >= 24.0 {
            if hoursSinceUtc < 48.0 {
                timeText =  timeText.appending("un día")
            }else {
                timeText =  timeText.appending("\(hoursSinceUtc/(daysInYear*24)) días")
            }
        }else {
            let formatter: DateFormatter = DateFormatter()
            
            formatter.dateFormat = "HH:mm";
            
            timeText = formatter.string(from: dateUtc);
        }

        return timeText
    }
}
