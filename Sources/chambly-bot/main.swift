import Foundation
import FeedKit
import SwiftSoup
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

NewsMonitor.start()
WeatherMonitor.start()

RunLoop.current.run()
