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

struct WeatherMonitor {
    
    static private var timer: ScheduleTimer?
    static let weatherURL = URL(string: "https://weather.gc.ca/city/pages/qc-58_metric_e.html")!
    
    static var prevWarning: String?
    
    static func start() {
        let twentyMinutes: TimeInterval = 60 * 20
        timer = ScheduleTimer(timeInterval: twentyMinutes) {
            URLSession.shared.dataTask(with: weatherURL) { (data, response, error) in
                guard let data = data else {return}
                guard let html = String(data: data, encoding: .utf8) else {return}
                do {
                    let doc = try SwiftSoup.parse(html)
                    
                    let warning = try doc.select("[class=col-xs-10 text-center]").array().compactMap{ try? $0.text() }.first
                    
                    if let newWarning = warning {
                        if let previousWarning = self.prevWarning {
                            if newWarning != previousWarning {
                                print("prev: \(previousWarning), now: \(newWarning)")
                                pushToWeChat(title: newWarning, description: weatherURL.absoluteString)
                                self.prevWarning = newWarning
                            }
                        } else {
                            print("new warning: \(newWarning)")
                            pushToWeChat(title: newWarning, description: weatherURL.absoluteString)
                            self.prevWarning = newWarning
                        }
                    }
//                    else {
//                        if let previousWarning = self.prevWarning {
//                            print("\(previousWarning) is gone.")
//                            pushToWeChat(title: previousWarning + " 解除了" , description: "")
//                            prevWarning = nil
//                        } else {
//                            print("nothing")
//                            prevWarning = nil
//                        }
//                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
}
