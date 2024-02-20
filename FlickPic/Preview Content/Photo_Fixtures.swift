//
//  Photo_Fixtures.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import Foundation

extension Photo {
    static func fixture(link: URL, mediaLink: URL, dateTaken: Date) -> Photo {
        let description = "<p><a href=\"https://www.flickr.com/people/137666638@N05/\">lotusfoodgallery</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/137666638@N05/26383794369/\" title=\"Fish Biryani Recipe – Biryani Recipe By Lotus Food Gallery\"><img src=\"https://live.staticflickr.com/4567/26383794369_eef84dbbae_m.jpg\" width=\"240\" height=\"135\" alt=\"Fish Biryani Recipe – Biryani Recipe By Lotus Food Gallery\" /></a></p> <p>Fish biryani is made of fish of your choice marinated with spices, fresh herbs and cooked with rice into a luxurious biryani. <br /> <br /> Fish Biryani – Lotus Food Gallery Fish is one of healthy meat that has so many benefits. Use fish in different forms. Instead to fried fish make delicious Fish Biryani. Fish is probably my favourite protein and this Fish Biryani recipe is one of a kind. It is easy to make, extremely flavourful and even those who do normally enjoy fish will LOVE this meal and request second helpings!<br /> <br /> via #YouTube recipe: <a href=\"https://www.youtube.com/watch?v=N8oHaoD30aM\" rel=\"nofollow\">www.youtube.com/watch?v=N8oHaoD30aM</a><br /> <br /> Made By : Lotus Food Gallery</p>"
        
        return Photo(title: "Test title",
                     link: link,
                     media: Photo.Media(m: mediaLink),
                     date_taken: dateTaken,
                     description: description,
                     published: "2024-02-18T21:32:16-08:00",
                     author: "wade weitzel",
                     tags: "test")
    }
}
