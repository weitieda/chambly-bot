import Foundation
import FeedKit
import SwiftSoup
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let wechat = WechatPusher()

let news = NewsMonitor(messagePusher: wechat)
let weather = WeatherMonitor(messagePusher: wechat)

RunLoop.current.run()
