//
//  Item.swift
//  PersonalDashboard
//
//  Created by Nachete on 20/06/2026.
//

import Foundation
import SwiftData

@Model
final class Task {
    var id: UUID
    var name: String
    
    init(name: String) {
        id = .init()
        self.name = name
    }
}
