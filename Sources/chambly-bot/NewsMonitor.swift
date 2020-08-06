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

final class NewsMonitor {
    private let feedURL = URL(string: "https://www.ville.chambly.qc.ca/feed/")!
    private var prevArticles: [Article]?
    
    private var timer: ScheduleTimer?
    private let messagePusher: Notifiable
    
    init(messagePusher: Notifiable) {
        self.messagePusher = messagePusher
        start()
    }
    
    private func start() {
        let hour: TimeInterval = 60 * 60
        timer = ScheduleTimer(timeInterval: hour) {
            self.fetchNews()
        }
    }
    
    private func fetchNews() {
        FeedParser(URL: feedURL).parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch result {
            case .failure(let e):
                print(e)
            case .success(let f):
                guard let rssFeedItems = f.rssFeed?.items else { return }
                let newArticles = rssFeedItems.compactMap { Article(title: $0.title, link: $0.link) }
                if let prevArticles = self.prevArticles {
                    let diff = newArticles.diff(from: prevArticles)
                    diff.forEach { self.messagePusher.notifyMe(title: $0.title, description: $0.link) }
                }
                self.prevArticles = newArticles
            }
        }
    }
    
    struct Article: Equatable, Hashable {
        let title: String
        let link: String
        
        init?(title: String?, link: String?) {
            guard let title = title, let link = link else {return nil}
            self.title = title
            self.link = link
        }
    }
}


