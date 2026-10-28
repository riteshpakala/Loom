//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import FeedKit

guard let feedURL = URL(string: "https://hnrss.org/frontpage") else {
    fatalError("invalid url")
}
let parser = FeedParser(URL: feedURL)

if #available(macOS 10.15.0, *) {
    guard let feed = await parser.parseAsyncAwait() else {
        fatalError("failed to fetch feed")
    }
    
    for item in feed.rssFeed?.items ?? [] {
        print(item.title)
    }
} else {
    // Fallback on earlier versions
}
