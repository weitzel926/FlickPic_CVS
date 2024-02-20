//
//  DateUtilities.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import Foundation

extension Date {
    static func createDate(month: Int, day: Int, year: Int) -> Date? {
        let dateString = "\(year)-\(month)-\(day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter.date(from: dateString) 
    }
}
