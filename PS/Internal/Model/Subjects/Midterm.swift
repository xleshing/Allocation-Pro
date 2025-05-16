//
//  Midterm.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/27.
//
import SwiftData
import Foundation

@Model
class Midterm: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()  // 唯一標識
    var name: String
    var date: Date                             // 日期
    var score: Double?                       // 分數
    var weight: Double                         // 佔比
    var isCompleted: Bool = false

    @Relationship(deleteRule: .nullify) var subject: Subject? // 所屬科目

    init(name: String, date: Date, score: Double?, weight: Double, subject: Subject) {
        self.date = date
        self.name = name
        self.score = score
        self.weight = weight
        self.subject = subject
    }
}
