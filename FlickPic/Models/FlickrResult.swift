//
//  FlckrResult.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import Foundation

struct FlickrResult: Codable {
    let title: String
    let link: URL
    let items: [Photo]
}
