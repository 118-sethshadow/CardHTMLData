//
//  SearchController.swift
//  TCGPlayerData
//
//  Created by Kartikeya Kaushal on 9/23/14.
//  Copyright (c) 2014 K. All rights reserved.
//

import Foundation

protocol SearchControllerProtocol {
    func didReceiveSearchResults(results: [Album])
}

class SearchController {
    
    var delegate: SearchControllerProtocol
    
    init(delegate: SearchControllerProtocol) {
        self.delegate = delegate
    }
    
    
    func makeCardList(theHTML:String) -> [Card] {
        
        var list:[Card] = []
        var name:NSString?
        var price:NSString?
        var imageURL:NSString?
        var endTag:String = "\""
        //println(theHTML)
        
        if !(theHTML.isEmpty){
            var scanner:NSScanner = NSScanner(string: theHTML)
            
            //check if we got a search results page
            if scanner.scanUpToString("<div class=\"SearchResults\" id=\"SearchResultsDiv\">", intoString: nil){
                
                while scanner.scanUpToString("<div class=\"cardImage\">", intoString: nil) {
                    //stop if you are going out of bounds
                    if scanner.scanUpToString("\"", intoString: nil) == false{
                        break;
                    }
                    scanner.scanUpToString("href=\"", intoString: nil)
                    scanner.scanLocation += 6
                    //get the image url
                    scanner.scanUpToString(endTag, intoString: &imageURL)
                    print(imageURL!)
                    scanner.scanUpToString("<div class=\"cardDetailsContainer\">", intoString: nil)
                    scanner.scanUpToString("href=\"", intoString:nil)
                    scanner.scanLocation += 6
                    scanner.scanUpToString(">", intoString: nil)
                    scanner.scanLocation += 1
                    //get the name of the card
                    scanner.scanUpToString("</a>", intoString: &name)
                    print(name!)
                    scanner.scanUpToString("<td class=\"price\">", intoString: nil)
                    if scanner.scanLocation < theHTML.characters.count{
                        scanner.scanLocation += 18
                        scanner.scanUpToString("<br/>", intoString: &price)
                    }
                    
                    //make the card and add it to the list
                    var card:Card = Card(name: name! as String, price: price! as String, imageURL: imageURL! as String)
                    list.append(card)
                }//end search parse
                
            }//end search check
            
            /*we got a single result instead
            else{
            scanner.scanUpToString("img src=\"", intoString: nil)
            scanner.scanLocation += 9
            scanner.scanUpToString(endTag, intoString: &image)
            scanner.scanUpToString("title=\"", intoString: nil)
            scanner.scanLocation += 7
            scanner.scanUpToString(endTag, intoString: &name)
            
            
            //make the card and add it to the list
            var card:Card = Card(name: name, number: nil, gameType: nil, cardType: nil, cardImage: image)
            println("\(name) and \(image)")
            list.append(card)
            }*/
            
        }
        //println(list.count)
        
        
        return list
    }
    
    func makeAlbumList(list:NSDictionary) -> [Album] {
        
        let albumList:[Album] = []
        var result: NSDictionary
        
        for result in list {
            
            }
        return albumList
        }
        
    
    
    /******************SEARCH OPTIONS*********************/
    func searchYugiohCardFor(searchTerm:String){
        
        let cardSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm = cardSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        //println(escapedSearchTerm)
        
        for pageNum in 1...7{
            //get("http://www.tcgplayer.com")
            get("http://shop.tcgplayer.com/yugioh/product/show?ProductName=\(cardSearchTerm)&PageNumber=\(pageNum)")
        }
        
    }
    
    func searchVanguardCard(searchTerm:String){
        let cardSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm = cardSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        print(escapedSearchTerm)
        for pageNum in 1...7{
            get("http://shop.tcgplayer.com/cardfight-vanguard/product/show?ProductName=\(escapedSearchTerm)&PageNumber=\(pageNum)")
        }
    }
    
    func searchAppStore(searchTerm:String){
        let albumSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options:
            NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm = albumSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        print(escapedSearchTerm)
            get("http://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=software")
        
    }
    
    func searchITunes(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=music&entity=album"
        get(urlPath)
    }
    
    
    
    /******************GET REQUEST*********************/
    func get(path:String) {
        var strData: String?
        var pageLinks: [String] = []
        var cardList: [Card] = []
        var albumList: [Album] = []
        let url: NSURL = NSURL(string:path)!
        let session = NSURLSession.sharedSession()
        print(path)
        
        
        //make the request task
        let task = session.dataTaskWithURL(url) {(data, response, error) -> Void in
            
            // println("Task Complete")
            if(error != nil) {
                print(error!.localizedDescription)
            }
            
            //strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println(strData!)
                
            let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary

            let results: NSArray = jsonResult["results"] as! NSArray
            print(jsonResult)
            
            for result in results{
                let album:Album = Album()
                album.title = result["trackName"] as? String
                if album.title == nil {
                    album.title = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                album.price = result["formattedPrice"] as? String
                if album.price == nil {
                    album.price = result["collectionPrice"] as? String
                    if album.price == nil {
                        let priceFloat: Float? = result["collectionPrice"] as? Float
                        let nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        if priceFloat != nil {
                            album.price = "$"+nf.stringFromNumber(priceFloat!)!
                        }
                    }
                }
                album.description = result["description"] as? String
                album.thumbnailImageURL = result["artworkUrl60"] as? String
                album.largeImageURL = result["artworkUrl100"] as? String
                album.artistURL = result["artistViewUrl"] as? String
                if album.artistURL == nil{
                    album.artistURL = ""
                }
                album.itemURL = result["collectionViewUrl"] as? String
                if album.itemURL == nil {
                    album.itemURL = result["trackViewUrl"] as? String
                }
                
                album.collectionId = result["collectionId"] as? Int
                albumList.append(album)
            }
            //cardList = self.makeCardList(strData!)
            self.delegate.didReceiveSearchResults(albumList)
        }
        task.resume()
        
        
        
        
    }
    
    
}
