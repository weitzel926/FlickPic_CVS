//
//  PhotoTests.swift
//  FlickPicTests
//
//  Created by Wade Weitzel on 2/19/24.
//

@testable import FlickPic
import XCTest

final class PhotoTests: XCTestCase {
    var photo: Photo? = nil
    
    override func setUp() {
        guard let link = URL(string: "https://picsum.photos/300/200"),
              let mediaLink = URL(string: "https://picsum.photos/300/200"),
              let dateTaken = Date.createDate(month: 12, day: 25, year: 2023) else {
            XCTFail("should never happen")
            return
        }
        
        photo = Photo.fixture(link: link, mediaLink: mediaLink, dateTaken: dateTaken)
    }
    
    func testDateTakenString() {
        guard let photo = photo else {
            XCTFail("should never happen")
            return
        }
        
        XCTAssertEqual(photo.dateTakenString, "Dec 25, 2023")
    }
}
