//
//  ViewController.swift
//  FlickrViewer
//
//  Created by yjiq150 on 07/01/2017.
//  Copyright © 2017 yjiq150. All rights reserved.
//

import UIKit
import Alamofire

typealias JSONDictionary = [String:AnyObject]

class ViewController: UIViewController {

    let feedURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json"
    
//    public static func serializeResponseJSON(
//        options: JSONSerialization.ReadingOptions,
//        response: HTTPURLResponse?,
//        data: Data?,
//        error: Error?)
//        -> Result<Any>
//    {
//        guard error == nil else { return .failure(error!) }
//        
//        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }
//        
//        guard let validData = data, validData.count > 0 else {
//            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
//        }
//        
//        do {
//            let json = try JSONSerialization.jsonObject(with: validData, options: options)
//            return .success(json)
//        } catch {
//            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(feedURL).responseString { [weak self] response in
            
            //debugPrint(response)
            
            guard let responseString = response.result.value else {
                // handle error
                return
            }
            
            // take out invalid JSON wrapper from Flickr
            let prefix = "jsonFlickrFeed("
            let postfix = ")"
            
            let startOffset = prefix.characters.count
            let endOffset = responseString.characters.count - postfix.characters.count - 1 
            
            if startOffset > responseString.characters.count || endOffset < 0 {
                // handle error
                return
            }
            
            let startIndex = responseString.index(responseString.startIndex, offsetBy: startOffset)
            let endIndex = responseString.index(responseString.startIndex, offsetBy: endOffset)

            let jsonString = responseString[startIndex...endIndex]
            
            
            if let data = jsonString.data(using: .utf8) {
                guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
                    return;
                }
                
                
                var feedList: [FeedItem] = []
                
                if let dics = responseObject?["items"] as? [JSONDictionary] {
//                    for feedItemDictionary in dics {
//                        if let feedItem = FeedItem(dictionary: feedItemDictionary) {
//                            feedList.append(feedItem)
//                        }
//                    }
                    feedList = dics.flatMap(FeedItem.init)
                }
                

                
            } else {
                // handle error
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

