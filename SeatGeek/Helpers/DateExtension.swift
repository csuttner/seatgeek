//
//  DateExtension.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Extension to assist with formatting of datetime data

import Foundation

extension Date {
    
    // Get date from API ISO format
    static func fromIso(_ iso: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: iso)!
    }
    
    // Format date for tableview display
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
}
