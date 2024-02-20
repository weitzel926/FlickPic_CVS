//
//  FlickrResultFixture.swift
//  FlickPicTests
//
//  Created by Wade Weitzel on 2/19/24.
//

@testable import FlickPic
import Foundation

extension FlickrResult {
    static func fixture() -> FlickrResult? {
        guard let link = URL(string: "https://picsum.photos/300/200"),
              let mediaLink = URL(string: "https://picsum.photos/300/200"),
              let datePublished = Date.createDate(month: 12, day: 25, year: 2023),
              let resultUrl = URL(string: "https://someurl") else {
            return nil
        }
        
        let photo = Photo.fixture(link: link, mediaLink: mediaLink, datePublished: datePublished)
            
        return FlickrResult(title: "Title", link: resultUrl, items: [photo])
    }
}
