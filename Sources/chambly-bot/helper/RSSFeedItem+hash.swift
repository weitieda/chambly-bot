//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import FeedKit

extension RSSFeedItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(link)
    }
}
