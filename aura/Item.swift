//
//  Item.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
