//
//  PhotoListTests.swift
//  FlickPicTests
//
//  Created by Wade Weitzel on 2/19/24.
//

@testable import FlickPic
import XCTest

final class PhotoListTests: XCTestCase {
    var photoList: PhotoList!
    var mockPhotoListManager: MockPhotoListManager!
    var fakePhoto: Photo!
    
    @MainActor override func setUp() {
        mockPhotoListManager = MockPhotoListManager()
        photoList = PhotoList(manager: mockPhotoListManager)
        
        guard let link = URL(string: "https://picsum.photos/300/200"),
              let mediaLink = URL(string: "https://picsum.photos/300/200"),
              let datePublished = Date.createDate(month: 12, day: 25, year: 2023) else {
            XCTFail("should never happen")
            return
        }
        
        fakePhoto = Photo.fixture(link: link, mediaLink: mediaLink, datePublished: datePublished)
    }
    
    @MainActor func testGetFlickrData_emptyKey() {
        mockPhotoListManager.throwsForEmptyKey = true
        
        photoList.photos = [fakePhoto, fakePhoto]
        
        let expectation = XCTestExpectation(description: "Async task completion")
        
        photoList.loadPhotos(key: "")
        
        // This is less than ideal.  Because loadPhotos calls an async function, we have to
        // sleep long enough for the (Mock function, it's super fast) to run.  We can accomplish
        // this by setting up an expectation and firing it off on a new DispatchQueue with
        // asyncAfter(deadline:).  This effectivley calls the block two seconds later than now,
        // and fulfills the expectation.  Then, the stuff we want to check happens after the
        // wait(for: timeout:).  This works, but makes for a few slow tests. That said, allowing
        // us to have loadPhotos(key:) stay synchronous is worth it.
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertFalse(photoList.inProgress)
        XCTAssertTrue(photoList.photos.isEmpty)
    }
    
    @MainActor func testGetFlickrData_error() {
        mockPhotoListManager.throwsForOtherError = true
        
        photoList.photos = [fakePhoto, fakePhoto]
        
        let expectation = XCTestExpectation(description: "Async task completion")
        
        photoList.loadPhotos(key: "")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertFalse(photoList.inProgress)
        XCTAssertEqual(photoList.lastError, "The operation couldn’t be completed. (FlickPic.PhotoListError error 1.)")
        XCTAssertTrue(photoList.showError)
        XCTAssertTrue(photoList.photos.count == 2)
    }
    
    @MainActor func testGetFlickrData_Cancelation() {
        mockPhotoListManager.throwsCancellation = true
        
        photoList.photos = [fakePhoto, fakePhoto]
        
        let expectation = XCTestExpectation(description: "Async task completion")
        
        photoList.loadPhotos(key: "")
        photoList.lastError = nil
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(photoList.inProgress)
        XCTAssertEqual(photoList.lastError, nil)
        XCTAssertFalse(photoList.showError)
        XCTAssertTrue(photoList.photos.count == 2)
    }
    
    @MainActor func testGetFlickrData_CancelationMethodTwo() {
        mockPhotoListManager.throwsCancellationMethod2 = true
        
        photoList.photos = [fakePhoto, fakePhoto]
        
        let expectation = XCTestExpectation(description: "Async task completion")
        
        photoList.loadPhotos(key: "")
        photoList.lastError = nil
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(photoList.inProgress)
        XCTAssertEqual(photoList.lastError, nil)
        XCTAssertFalse(photoList.showError)
        XCTAssertTrue(photoList.photos.count == 2)
    }
    
    @MainActor func testGetFlickrData_HappyPath() {
        mockPhotoListManager.happyPath = true
        
        photoList.photos = [fakePhoto, fakePhoto]
        
        let expectation = XCTestExpectation(description: "Async task completion")
        
        photoList.loadPhotos(key: "")
        photoList.lastError = nil
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertFalse(photoList.inProgress)
        XCTAssertEqual(photoList.lastError, nil)
        XCTAssertFalse(photoList.showError)
        XCTAssertTrue(photoList.photos.count == 1)
    }
}

class MockPhotoListManager: Flickrable {
    var throwsForEmptyKey: Bool = false {
        didSet {
            if throwsForEmptyKey {
                throwsForOtherError = false
                throwsCancellation = false
                throwsCancellationMethod2 = false
            }
        }
    }
    
    var throwsForOtherError: Bool = false {
        didSet {
            if throwsForOtherError {
                throwsForEmptyKey = false
                throwsCancellation = false
                throwsForEmptyKey = false
                throwsCancellationMethod2 = false
            }
        }
    }
    
    var throwsCancellation: Bool = false {
        didSet {
            if throwsCancellation {
                throwsForEmptyKey = false
                throwsForOtherError = false
                throwsCancellationMethod2 = false
            }
        }
    }
    
    var throwsCancellationMethod2: Bool = false {
        didSet {
            if throwsCancellationMethod2 {
                throwsForEmptyKey = false
                throwsForOtherError = false
                throwsCancellation = false
            }
        }
    }
    
    var happyPath: Bool = false {
        didSet {
            throwsForEmptyKey = false
            throwsForOtherError = false
            throwsCancellation = false
            throwsCancellationMethod2 = false
        }
    }
    
    func getFlickrData(key: String) async throws -> FlickPic.FlickrResult? {
        if throwsForEmptyKey {
            throw PhotoListError.emptyKey
        } else if throwsForOtherError {
            throw PhotoListError.invalidURL
        } else if throwsCancellation {
            throw CancellationError()
        } else if throwsCancellationMethod2 {
            throw URLError(.cancelled)
        } else if happyPath {
            return FlickrResult.fixture()
        }
        
        return nil
    }
}
