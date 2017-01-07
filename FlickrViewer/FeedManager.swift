//
//  FeedManager.swift
//  FlickrViewer
//
//  Created by yjiq150 on 07/01/2017.
//  Copyright © 2017 yjiq150. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONDictionary = [String:AnyObject]


class FeedManager {
    
    var currentIndex = 0
    
    let feedURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json"

    var feedList: [FeedItem] = []
    var feedItemByLink: [String:FeedItem] = [:]
    
    init() {
        
    }
    
    private func appendFeed(items: [FeedItem]) {
        
        for feedItem in items {
            // check uniqueness
            if (feedItemByLink[feedItem.link] == nil) {
                feedItemByLink[feedItem.link] = feedItem
                feedList.append(feedItem)
            }
        }
    }
    
    func currentItem() -> FeedItem? {
        if feedList.count == 0 {
            return nil
        }
        
        return feedList[currentIndex]
    }
    
    func nextItem() -> FeedItem? {
        if feedList.count == 0 {
            return nil
        }
        
        currentIndex += 1
        currentIndex = currentIndex % feedList.count
        
        fetchFeedsIfNeeded()
        
        return feedList[currentIndex]
    }
    
    func fetchFeedsIfNeeded(success: (() -> ())? = nil, fail: (() -> ())? = nil) {
    
        debugPrint("current: \(currentIndex), total count: \(feedList.count)")
        // if the number of fetched less than 5, fetch more.
        if feedList.count - currentIndex  > 5 {
            return
        }
        
        debugPrint("fetch more")
        
        Alamofire.request(feedURL).responseString { [weak self] response in
            
            guard let responseString = response.result.value else {
                fail?()
                return
            }
            
            // take out invalid JSON wrapper from Flickr
            let prefix = "jsonFlickrFeed("
            let postfix = ")"
            
            let startOffset = prefix.characters.count
            let endOffset = responseString.characters.count - postfix.characters.count - 1
            
            if startOffset > responseString.characters.count || endOffset < 0 {
                fail?()
                return
            }
            
            let startIndex = responseString.index(responseString.startIndex, offsetBy: startOffset)
            let endIndex = responseString.index(responseString.startIndex, offsetBy: endOffset)
            
            let jsonString = responseString[startIndex...endIndex]
            
            
            if let data = jsonString.data(using: .utf8) {
                guard let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
                    return;
                }
                
                if let dics = responseObject?["items"] as? [JSONDictionary] {
                    let feedItems = dics.flatMap(FeedItem.init)
                    self?.appendFeed(items: feedItems)
                    success?()
                }
                
            } else {
                fail?()
            }
            
        }
    }
    
    func clearFeeds() {
        currentIndex = 0
        feedList.removeAll()
        feedItemByLink.removeAll()
    }
}
