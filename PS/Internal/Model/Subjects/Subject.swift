import SwiftData
import Foundation

@Model
class Subject: Identifiable {
    
    @Attribute(.unique) var id:UUID = UUID()
    var name: String
    var assignments: [Assignment] = []  // 作業（多對一）
    var midterms: [Midterm] = []        // 其中（多對一）
    var finals: [Final] = []            // 期末（多對一）
    var quizzes: [Quiz] = []            // 小考（多對一）
    var others: [Other] = []            // 其他（多對一）
    var targetscore: Double = 60   // 目標
    var bonusscore: Double = 0   // 額外分數
    var canpass: Bool = true
    
    @Relationship(deleteRule: .nullify) var user: User?
    
    init(name: String, user: User) {
        self.name = name
        self.user = user
    }
    
    func Perweight(mode:Int) -> (result:Double, total:Double, k:Double, pass:Bool){
        var midterm:Double = 0
        var final:Double = 0
        var assignment:Double = 0
        var quiz:Double = 0
        var other:Double = 0
        
        let midterms = midterms.filter { $0.score == nil }
        let finals = finals.filter { $0.score == nil }
        let assignments = assignments.filter { $0.score == nil }
        let quizzes = quizzes.filter { $0.score == nil }
        let others = others.filter { $0.score == nil }
        
        for m in midterms{
            midterm += m.weight
        }
        for f in finals{
            final += f.weight
        }
        for a in assignments{
            assignment += a.weight
        }
        for q in quizzes{
            quiz += q.weight
        }
        for o in others{
            other += o.weight
        }
        
        let total = (midterm + final + assignment + quiz + other)
        let totalscore =  calculateAverage()
        let result = (targetscore - bonusscore - totalscore)
        
        //加權模式
        var pass = true
        
        let midtermsWeights = midterms.map { $0.weight }
        let finalsWeights = finals.map { $0.weight }
        let assignmentsWeights = assignments.map { $0.weight }
        let quizzesWeights = quizzes.map { $0.weight }
        let othersWeights = others.map { $0.weight }
        
        // 将所有的 weight 合并到一个数组中
        let allWeights: [Double] = midtermsWeights + finalsWeights + assignmentsWeights + quizzesWeights + othersWeights
        
        
        let denominator = allWeights.map { ($0 * $0) / 100.0 }.reduce(0, +)
        
        let k = result / denominator
        
        for i in allWeights{
            if mode == 1{
                if i*k > 100{
                    pass = false
                }
            }else if mode == 0{
                if (result / total / 100) > 100{
                    pass = false
                }
            }
                
        }
        
        return (result, total, k, pass)
    }
    
    
    func calculateAverage() -> Double {
        var totalScore = 0.0

        for midterm in midterms {
            totalScore += (midterm.score ?? 0) * midterm.weight / 100
        }

        for final in finals {
            totalScore += (final.score ?? 0) * final.weight / 100
        }

        for quiz in quizzes {
            totalScore += (quiz.score ?? 0) * quiz.weight / 100
        }

        for other in others {
            totalScore += (other.score ?? 0) * other.weight / 100
        }

        for assignment in assignments {
            totalScore += (assignment.score ?? 0) * assignment.weight / 100
        }
        return  totalScore
    }
    
    func calculateTotalWeight() -> Double{
        var tatolweight = 0.0
        for m in self.midterms{
            tatolweight += m.weight
        }
        for f in self.finals{
            tatolweight += f.weight
        }
        for q in self.quizzes{
            tatolweight += q.weight
        }
        for a in self.assignments{
            tatolweight += a.weight
        }
        for o in self.others{
            tatolweight += o.weight
        }
        return tatolweight
    }

}
