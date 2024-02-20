//
//  Photo.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import Foundation

struct Photo: Codable, Hashable {
    let title: String
    let link: URL
    let media: Media
    let date_taken: Date
    let description: String
    let published: String
    let author: String
    let tags: String
    
    struct Media: Codable, Hashable {
        let m: URL
    }
    
    var photoURL: URL {
        return media.m
    }
    
    var dateTakenString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date_taken)
    }
}
