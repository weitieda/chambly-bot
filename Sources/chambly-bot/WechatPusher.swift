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
    let key = "SCU54044T685f659ff69e1bcf38f06083b45369495d101bb3a4350"

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
