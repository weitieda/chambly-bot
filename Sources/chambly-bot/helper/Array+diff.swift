//
//  File.swift
//  
//
//  Created by tieda on 2020-08-02.
//

import Foundation

extension Array where Element: Hashable {
    func diff(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
