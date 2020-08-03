//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import Foundation

final class ScheduleTimer {
    
    private var timer: DispatchSourceTimer?
    
    private let interval: TimeInterval
    private let action: () -> Void
    
    init(timeInterval: TimeInterval, action: @escaping () -> Void) {
        self.interval = timeInterval
        self.action = action
        startTimer()
    }
    
    private func startTimer() {
        let queue = DispatchQueue(label: "chambly-bot")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: interval, leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            self?.action()
        }
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        self.stopTimer()
    }
}
