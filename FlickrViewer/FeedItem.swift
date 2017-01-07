//
//  FeedItem.swift
//  FlickrViewer
//
//  Created by yjiq150 on 07/01/2017.
//  Copyright © 2017 yjiq150. All rights reserved.
//

import Foundation

class FeedItem {
    // index field
    var link: String
    
    var title: String?
    var mediaURL: String?
    var description: String?
    
    init?(dictionary: [String:AnyObject]) {
        
        guard let link = dictionary["link"] as? String else {
            return nil
        }
        
        self.link = link
        
        title = dictionary["title"] as? String
        
        if let media = dictionary["media"] as? [String:AnyObject] {
            mediaURL = media["m"] as? String
        }
        description = dictionary["description"] as? String
    }
}
