//
//  Assignment.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/27.
//
import SwiftData
import Foundation

@Model
class Assignment: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var score: Double?                     // 分數
    var weight: Double                         // 佔比
    var date: Date
    var isCompleted: Bool = false

    @Relationship(deleteRule: .nullify) var subject: Subject? // 所屬科目

    init(name: String, date: Date, score: Double?, weight: Double, subject: Subject) {
        self.name = name
        self.score = score
        self.weight = weight
        self.date = date
        self.subject = subject
    }

}
