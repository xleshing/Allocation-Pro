//
//  Final.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/27.
//
import SwiftData
import Foundation


@Model
class Final: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var date: Date
    var score: Double?
    var weight: Double
    var isCompleted: Bool = false

    @Relationship(deleteRule: .nullify) var subject: Subject?

    init(name: String, date: Date, score: Double?, weight: Double, subject: Subject) {
        self.name = name
        self.date = date
        self.score = score
        self.weight = weight
        self.subject = subject
    }
}
