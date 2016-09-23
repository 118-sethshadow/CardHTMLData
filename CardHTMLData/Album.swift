//
//  Album.swift
//  SwiftTutorial
//
//  Created by Jameson Quave on 6/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class Album {
    var title: String?
    var price: String?
    var description: String?
    var thumbnailImageURL: String?
    var largeImageURL: String?
    var itemURL: String?
    var artistURL: String?
    var collectionId: Int?
    var image: UIImage?
    
    init() {
        self.title = ""
        self.price = ""
        self.description = ""
        self.thumbnailImageURL = ""
        self.largeImageURL = ""
        self.itemURL = ""
        self.artistURL = ""
        self.collectionId = 0
        self.image = nil
    }
    
    init(name: String!, price: String!, thumbnailImageURL: String!, largeImageURL: String!, itemURL: String!, artistURL: String!, collectionId: Int?) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
}