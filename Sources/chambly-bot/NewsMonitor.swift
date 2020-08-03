//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import Foundation
import FeedKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct NewsMonitor {
    static private let feedURL = URL(string: "https://www.ville.chambly.qc.ca/feed/")!
    static private var prevArticles: [Article]?
    
    static private var timer: ScheduleTimer?
    
    static func start() {
        let hour: TimeInterval = 60 * 60
        timer = ScheduleTimer(timeInterval: hour) {
            fetchNews()
        }
    }
    
    static private func fetchNews() {
        FeedParser(URL: feedURL).parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch result {
            case .failure(let e):
                print(e)
            case .success(let f):
                guard let rssFeedItems = f.rssFeed?.items else { return }
                let newArticles = rssFeedItems.compactMap { Article(title: $0.title, link: $0.link) }
                if let prevArticles = prevArticles {
                    let diff = newArticles.diff(from: prevArticles)
                    print(diff.isEmpty ? "[News] No new ones" : "[News] Get new one")
                    diff.forEach { pushToWeChat(title: $0.title, description: $0.link) }
                }
                prevArticles = newArticles
            }
        }
    }
}

struct Article {
    let title: String
    let link: String
    
    init?(title: String?, link: String?) {
        guard let title = title, let link = link else {return nil}
        self.title = title
        self.link = link
    }
}

extension Article: Equatable, Hashable { }

