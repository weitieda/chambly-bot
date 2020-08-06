//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import Foundation
import SwiftSoup
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class WeatherMonitor {
    
    private var timer: ScheduleTimer?
    private let weatherURL = URL(string: "https://weather.gc.ca/city/pages/qc-58_metric_e.html")!
    
    private var prevWarning: String?
    
    private let messagePusher: Notifiable
    
    init(messagePusher: Notifiable) {
        self.messagePusher = messagePusher
        start()
    }
    
    private func start() {
        let twentyMinutes: TimeInterval = 60 * 20
        timer = ScheduleTimer(timeInterval: twentyMinutes) {
            URLSession.shared.dataTask(with: self.weatherURL) { (data, response, error) in
                guard let data = data else {return}
                guard let html = String(data: data, encoding: .utf8) else {return}
                do {
                    let doc = try SwiftSoup.parse(html)
                    
                    let warning = try doc.select("[class=col-xs-10 text-center]").array().compactMap{ try? $0.text() }.first
                    
                    if let newWarning = warning {
                        if let previousWarning = self.prevWarning {
                            if newWarning != previousWarning {
                                self.messagePusher.notifyMe(title: newWarning, description: self.weatherURL.absoluteString)
                                self.prevWarning = newWarning
                            }
                        } else {
                            self.messagePusher.notifyMe(title: newWarning, description: self.weatherURL.absoluteString)
                            self.prevWarning = newWarning
                        }
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
}
