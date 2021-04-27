//
//  Constants.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/21/21.
//

import Foundation
struct K {
    static let cellIdentifier = "DisplayCell"
    static let cellNibName = "DisplayCell"
    
    struct Tables {
        static let Collection = "Collections"
        static let Item = "Items"
    }
    
    struct ItemType {
        static let movie = "Movie"
        static let tv = "Telivision"
        static let book = "Book"
        static let music = "Music"
        static let generic = "Generic"
        static let placeholder = ""
    }
    
    struct Fields {
        static let objectId = "objectId"
        static let title = "title"
        static let notes = "notes"
        static let genre = "genre"
        static let author = "author"
        static let type = "type"
        static let image = "image"
        static let series = "series"
        static let own = "own"
        static let listenedToWatchedRead = "listenedToWatchedRead"
        static let volume = "volume"
        static let format = "format"
        static let collectionId = "collectionId"
        static let userId = "userId"
        static let website = "website"
    }
    
   struct Color {
        static let grey = "#e4e3e3"
        static let lightTeal = "84a9ac"
        static let mediumTeal = "3b6978"
        static let darlTeal = "204051"
    }
    
    struct mediaFormat {
        static let paperBack = "Paperback"
        static let dvd = "DVD"
        static let hardCover = "Hard Cover"
        static let audiobook = "Audiobook"
        static let cd = "CD"
        static let digital = "Digital"
        static let generic = "Generic"
    }
}
