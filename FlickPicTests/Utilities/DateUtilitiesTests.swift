//
//  DateUtilitiesTests.swift
//  FlickPicTests
//
//  Created by Wade Weitzel on 2/19/24.
//

@testable import FlickPic
import XCTest

final class DateUtilitiesTests: XCTestCase {
    func testDateUtilities() {
        let validDate = Date.createDate(month: 12, day: 25, year: 2023)
        
        // Use the other (and less reliable) way of generating a date for the test
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 12
        dateComponents.day = 25
        
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents) {
            XCTAssertEqual(validDate, date)
        } else {
            XCTFail("Failed to create date")
        }
        
        let invalidDate = Date.createDate(month: 13, day: 25, year: 2023)
        
        XCTAssertNil(invalidDate)
    }
}
