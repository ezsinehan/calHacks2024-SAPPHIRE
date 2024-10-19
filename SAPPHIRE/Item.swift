//
//  Item.swift
//  SAPPHIRE
//
//  Created by EZ on 10/18/24.
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
