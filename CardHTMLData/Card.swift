//
//  Card.swift
//  TCGPlayerData
//
//  Created by Kartikeya Kaushal on 9/23/14.
//  Copyright (c) 2014 K. All rights reserved.
//

import UIKit

class Card {
    var name:String
    var price: String
    var imageURL:String
    var image: UIImage?
    
    
    
    init(name:String, price:String, imageURL:String){
        self.name = name
        self.price = price
        self.imageURL = imageURL
        
    }
}