//
//  PhotoList.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import Foundation

enum PhotoListError: Error {
    case emptyKey
    case invalidURL
}

actor PhotoListManager: Flickrable {
    func getFlickrData(key: String) async throws -> FlickrResult? {
        guard key != "" else {
            throw PhotoListError.emptyKey
        }
        
        // TODO: Put the URL in a plist
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(key)") else {
            throw PhotoListError.invalidURL
        }
                
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(FlickrResult.self, from: data)
    }
}

protocol Flickrable {
    func getFlickrData(key: String) async throws -> FlickrResult?
}

@Observable @MainActor
class PhotoList {
    var photos: [Photo] = []
    var task: Task<Void, Never>? = nil
    var showError: Bool = false  // Why can't this be private(set)
    var lastError: String? = nil
    
    private(set) var inProgress: Bool = false
    private(set) var manager: Flickrable
    
    init(manager: Flickrable) {
        self.manager = manager
    }
    
    func clearError() {
        showError = false
        lastError = nil
    }
    
    func loadPhotos(key: String) {
        // Mark inProgress to true so the UI can start to show the spinny
        inProgress = true
        
        // If there is a prior task (from prior typing) pending, cancel it
        if let task = task {
            task.cancel()
            self.task = nil
        }
        
        // Create and execute the new task to get the data from the Flckr API
        task = Task {
            do {
                if let result = try await manager.getFlickrData(key: key) {
                    photos = result.items
                    inProgress = false
                }
            } catch PhotoListError.emptyKey {
                // If we searched on an empty key, reset the photos array so the user sees a blank page
                inProgress = false
                photos = []
            } catch is CancellationError {
                // Cancellation can theoretically throw either of these errors, we want to ignore them.
                // A cancellation happens because a new task has started, so we don't want to kill the progress UI
            } catch URLError.cancelled {
                // Cancellation can theoretically throw either of these errors, we want to ignore them.
                // A cancellation happens because a new task has started, so we don't want to kill the progress UI
            } catch {
                // Prep to show an alert on a real failure we might care about
                inProgress = false
                showError = true
                lastError = error.localizedDescription
                return
            }
            
        }
    }
}
