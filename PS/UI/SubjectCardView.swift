import SwiftUI
import SwiftData

struct SubjectCardView: View {
    var subject: Subject
    @EnvironmentObject var appState: AppState
    @State private var refreshID = UUID()
    @Environment(\.modelContext) private var context
    @State var showEdit = false
    @State var showPredict = false
    @State var showAlert = false
    @State var Alert = false
    
    func calculateAverage() -> String {
        var totalScore = 0.0

        for midterm in subject.midterms {
            totalScore += (midterm.score ?? 0) * midterm.weight / 100
        }

        for final in subject.finals {
            totalScore += (final.score ?? 0) * final.weight / 100
        }

        for quiz in subject.quizzes {
            totalScore += (quiz.score ?? 0) * quiz.weight / 100
        }

        for other in subject.others {
            totalScore += (other.score ?? 0) * other.weight / 100
        }

        for assignment in subject.assignments {
            totalScore += (assignment.score ?? 0) * assignment.weight / 100
        }

        return totalScore / (subject.targetscore - subject.bonusscore) * 100 < 100 ? String(format: "%.1f", totalScore / (subject.targetscore - subject.bonusscore) * 100) : "100"
    }
    
    func allweight() -> Double{
        var result:Double = 0
        let midtermsWeights = subject.midterms.map { $0.weight }
        let finalsWeights = subject.finals.map { $0.weight }
        let assignmentsWeights = subject.assignments.map { $0.weight }
        let quizzesWeights = subject.quizzes.map { $0.weight }
        let othersWeights = subject.others.map { $0.weight }

        // 将所有的 weight 合并到一个数组中
        let allWeights: [Double] = midtermsWeights + finalsWeights + assignmentsWeights + quizzesWeights + othersWeights
        
        for w in allWeights{
            result += w
        }
        return result
    }
    
    
    var body: some View {
        ZStack{
            HStack {
                VStack {
                    Text(calculateAverage() == "0.0" ? "-.-" : calculateAverage())
                        .font(.title)
                        .bold()
                        .frame(width: 75, height: 100)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                }
                Spacer().frame(width: 30)
                VStack(alignment: .leading) {
                    if subject.canpass{
                        Text(subject.name)
                            .font(.largeTitle)
                            .bold()
                    }else{
                        Text(subject.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                    }
                        
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center) {
                            let quizzes = subject.quizzes
                            ForEach(quizzes, id: \.self) { quiz in
                                if quiz.score == nil {
                                    Text("-")
                                }else if Int(quiz.score ?? 0) < 60 {
                                    Text("\(Int(quiz.score ?? 0))").foregroundColor(.red)
                                }else{
                                    Text("\(Int(quiz.score ?? 0))")
                                }
                            }
                        }
                    }
                    .font(.headline)
                }
                Spacer()
            }
            .padding()
            .frame(width: 380, height: 135)
            .contentShape(Rectangle())
            .cornerRadius(12)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                // 预测成绩按钮
                Button {
                    if allweight() < 100 {
                        showAlert = true
                    }else if calculateAverage() == "100" {
                        Alert = true
                    }else{
                        showPredict = true // 触发預測模式
                    }
                } label: {
                    Label("預測", systemImage: "chart.bar") // SF Symbol 图标
                }
                .tint(.green) // 预测按钮颜色
                
                Button {
                    showEdit = true // 触发编辑模式
                } label: {
                    Label("編輯", systemImage: "pencil")
                }
                .tint(.blue) // 编辑按钮颜色
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    context.delete(subject) // 删除操作
                } label: {
                    Label("刪除", systemImage: "trash")
                }
            }
            // 背景完整圓形
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 5)
                .opacity(0.2)
                .foregroundColor(.gray)
                .frame(width: 380, height: 135)
            
            // 進度條
            RoundedRectangle(cornerRadius: 12)
                .trim(from: 0.0, to: Double(calculateAverage())! / 100) // 進度百分比
                .stroke(Color(red: 0.3, green: 0.8, blue: 0.8),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -180))
                .frame(width: 380, height: 135)
        }
        .sheet(isPresented: $showEdit){
            EditSubjectView(subject: subject)
        }
        .sheet(isPresented: $showPredict){
            PredictSubjectView(subject: subject)
        }
        .alert("提示", isPresented: $showAlert) {
                    Button("確定", role: .cancel) {} // 取消按钮
                } message: {
                    Text("科目總權重少於100。")
                }
        .alert("提示", isPresented: $Alert) {
                    Button("確定", role: .cancel) {} // 取消按钮
                } message: {
                    Text("已達標不用預測。")
                }
        .id(refreshID) // 强制刷新
    }
}
