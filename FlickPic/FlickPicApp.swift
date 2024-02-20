//
//  FlickPicApp.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import SwiftUI

@main
struct FlickPicApp: App {
    var body: some Scene {
        WindowGroup {
            let photoList = PhotoList(manager: PhotoListManager())
            FlickPicView(photoList: photoList)
        }
    }
}
