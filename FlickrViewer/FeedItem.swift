//
//  FeedItem.swift
//  FlickrViewer
//
//  Created by yjiq150 on 07/01/2017.
//  Copyright © 2017 yjiq150. All rights reserved.
//

import Foundation


//title: "کانادا Canon 5D Mark III Lens 24-70 mm Shot 1/60 sec F 7 mm ISO 100 @Pegaharshadi #اینستاگرام_نورنگار #کانن #دوربین #عکاسی #کانادا",
//link: "https://www.flickr.com/photos/noornegar/31316914284/",
//media: {
//    m: "https://farm1.staticflickr.com/659/31316914284_109f25d5cb_m.jpg"
//},
//date_taken: "2017-01-07T02:06:27-08:00",
//description: " <p><a href="https://www.flickr.com/people/noornegar/">Noornegar</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/noornegar/31316914284/" title="کانادا Canon 5D Mark III Lens 24-70 mm Shot 1/60 sec F 7 mm ISO 100 @Pegaharshadi #اینستاگرام_نورنگار #کانن #دوربین #عکاسی #کانادا"><img src="https://farm1.staticflickr.com/659/31316914284_109f25d5cb_m.jpg" width="240" height="160" alt="کانادا Canon 5D Mark III Lens 24-70 mm Shot 1/60 sec F 7 mm ISO 100 @Pegaharshadi #اینستاگرام_نورنگار #کانن #دوربین #عکاسی #کانادا" /></a></p> <p>via Instagram <a href="http://bit.ly/2hZXPP2" rel="nofollow">bit.ly/2hZXPP2</a></p>",
//published: "2017-01-07T10:06:27Z",
//author: "nobody@flickr.com ("Noornegar")",
//author_id: "118261982@N04",
//tags: "noornegar instagram نورنگار دوربین عکس عکاسی"


class FeedItem {
    var title: String
    var link: String
    var media: String
    var description: String
    
    init(dictionary: [String:AnyObject]) {
        
        title = dictionary["title"] as? String ?? ""
        link = dictionary["link"] as? String ?? ""
        media = dictionary["media"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
    }
}
