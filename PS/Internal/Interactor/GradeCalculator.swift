import Foundation

class GradeCalculator {
    static func calculateAverage(_ grades: [Double]) -> Double {
        guard !grades.isEmpty else { return 0.0 }
        return grades.reduce(0, +) / Double(grades.count)
    }
}
