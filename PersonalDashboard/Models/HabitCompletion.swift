//
//  HabitCompletion.swift
//  PersonalDashboard
//
//  Created by Nachete on 28/07/2026.
//

import Foundation
import SwiftData

@Model
final class HabitCompletion {
    @Attribute(.unique) var id: UUID
    
    /// Día lógico al que pertenece la finalización,
    /// normalizado al comienzo del día.
    var day: Date
    
    /// Instante real en el que el usuario lo marcó.
    var completedAt: Date
    var habit: Habit?
    
    init(
        id: UUID = UUID(),
        day: Date,
        completedAt: Date = .now,
        habit: Habit
    ) {
        self.id = id
        self.day = Calendar.current.startOfDay(for: day)
        self.completedAt = completedAt
        self.habit = habit
    }
}
