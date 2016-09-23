//
//  DetailViewController.swift
//  CardHTMLData
//
//  Created by Kartikeya Kaushal on 9/25/14.
//  Copyright (c) 2014 K. All rights reserved.
//

import Foundation
import UIKit


class DetailViewController: UIViewController {
    
    var thumbnail:UIImageView = UIImageView(frame: CGRectMake(50, 150, 100, 100))
    var name:UILabel = UILabel(frame: CGRectMake(170, 165, 180, 50))
    var price:UILabel = UILabel(frame: CGRectMake(170, 185, 180, 50))
    var appDescription:UITextView = UITextView(frame: CGRectMake(50, 300, 240, 140))
    
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(albumInfo:Album, imageInfo:UIImage?) {
        if(imageInfo != nil) {
            thumbnail.image = imageInfo!
        }
        name.text = albumInfo.title
        price.text = albumInfo.price
        appDescription.text = albumInfo.description
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(thumbnail)
        self.view.addSubview(name)
        self.view.addSubview(price)
        self.view.addSubview(appDescription)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
