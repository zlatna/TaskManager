//
//  DateFormatters.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 09/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class CustomDateFormatter {
    static var defaultDateFormat: String {
        return "MMM dd,yyyy - hh:mm"
    }    
    static func defaultFormatedDate(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = defaultDateFormat
        let dateString = dateformatter.string(from: date as Date)
        return dateString
    }
}
