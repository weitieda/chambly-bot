//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol Notifiable {
    func notifyMe(title: String, description: String)
}

struct WechatPusher: Notifiable {
    let key = ""

    func notifyMe(title: String, description: String) {
        let queryItems = [
            URLQueryItem(name: "text", value: title),
            URLQueryItem(name: "desp", value: description)
        ]
        var urlComps = URLComponents(string: "https://sc.ftqq.com/\(key).send")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        URLSession.shared.dataTask(with: url).resume()
    }
}
