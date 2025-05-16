//
//  PredictSubjectView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/9.
//

import SwiftUI
import SwiftData
import Foundation

struct PredictSubjectView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @State private var isAdding: Bool = false
    @State private var selectedExamType: String = "期中" // 預設選擇「期中」
    @State private var refreshID = UUID()
    var subject: Subject
    
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
    
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                ZStack{
                    // 卡片頭部
                    HStack(alignment: .center) {
                        // 平均分數
                        Text(calculateAverage() == "0.0" ? "-.-" : calculateAverage())
                            .font(.title)
                            .bold()
                            .frame(width: 75, height: 100)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        
                        Spacer().frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text(subject.name)
                                .font(.largeTitle)
                                .bold()
                        }
                        
                        Spacer()
                    }
                    .frame(width: 345, height: 100)
                    .padding()
                    .cornerRadius(12)
                    
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
                }.padding()
                
                
                HStack {
                    Spacer()
                    ForEach(["期中", "期末", "作業", "小考", "其他"], id: \.self) { type in
                        Text(type)
                            .font(.subheadline)
                            .foregroundColor(selectedExamType == type ? .white : .primary)
                            .padding(10)
                            .background(
                                selectedExamType == type ? Color.blue : Color.clear
                            )
                            .cornerRadius(12)
                            .onTapGesture {
                                selectedExamType = type // 更新選擇的考試類型
                            }
                    }
                    Spacer()
                }
                

                
                // 動態顯示選擇的類型數據
                if let items = getSelectedItems() as? [Midterm] {
                    PredictSectionView(
                        subject: subject,
                        title: "\(selectedExamType)資訊",
                        items: items)
                }else if let items = getSelectedItems() as? [Final] {
                    PredictSectionView(
                        subject: subject,
                        title: "\(selectedExamType)資訊",
                        items: items)
                }else if let items = getSelectedItems() as? [Quiz] {
                    PredictSectionView(
                        subject: subject,
                        title: "\(selectedExamType)資訊",
                        items: items)
                }else if let items = getSelectedItems() as? [Assignment] {
                    PredictSectionView(
                        subject: subject,
                        title: "\(selectedExamType)資訊",
                        items: items)
                }else if let items = getSelectedItems() as? [Other] {
                    PredictSectionView(
                        subject: subject,
                        title: "\(selectedExamType)資訊",
                        items: items)
                } else {
                    Text("沒有相關數據")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
            }
        }.id(refreshID) // 强制刷新
    }
    
    /// 根據選擇的類型返回對應數據
    func getSelectedItems() -> [Any]? {
        switch selectedExamType {
        case "期中":
            return subject.midterms.filter { $0.score == nil }
        case "期末":
            return subject.finals.filter { $0.score == nil }
        case "作業":
            return subject.assignments.filter { $0.score == nil }
        case "小考":
            return subject.quizzes.filter { $0.score == nil }
        case "其他":
            return subject.others.filter { $0.score == nil }
        default:
            return nil
        }
    }
    

}
    

// 顯示數據的視圖
struct PredictSectionView<Item: Identifiable>: View {
    @Environment(\.modelContext) private var context
    var subject: Subject
    let title: String
    let items: [Item]

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .bold()
            List {
                ForEach(items) { item in
                    PredictRowView(subject:subject, item: item)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}



// 不同類型的視圖
struct PredictRowView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @State var canpass:Bool = true
    let subject:Subject
    
    func calculateAverage() -> Double {
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
        return  totalScore
    }
    
    func Perweight(subject:Subject) -> (result:Double, total:Double, k:Double){
        subject.canpass = subject.Perweight(mode: appState.predictmode).pass
        var midterm:Double = 0
        var final:Double = 0
        var assignment:Double = 0
        var quiz:Double = 0
        var other:Double = 0
        
        let midterms = subject.midterms.filter { $0.score == nil }
        let finals = subject.finals.filter { $0.score == nil }
        let assignments = subject.assignments.filter { $0.score == nil }
        let quizzes = subject.quizzes.filter { $0.score == nil }
        let others = subject.others.filter { $0.score == nil }
        
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
        let result = (subject.targetscore - subject.bonusscore - totalscore)
        
        //加權模式
        
        let midtermsWeights = midterms.map { $0.weight }
        let finalsWeights = finals.map { $0.weight }
        let assignmentsWeights = assignments.map { $0.weight }
        let quizzesWeights = quizzes.map { $0.weight }
        let othersWeights = others.map { $0.weight }
        
        // 将所有的 weight 合并到一个数组中
        let allWeights: [Double] = midtermsWeights + finalsWeights + assignmentsWeights + quizzesWeights + othersWeights
        
        
        let denominator = allWeights.map { ($0 * $0) / 100.0 }.reduce(0, +)
        
        let k = result / denominator
        
        return (result, total, k)
    }

    
    
    func formatdate(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
//    func canpass(result:Any) -> Bool{
//        var pass:Bool = true
//        if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 || Perweight(subject: subject).k * result.weight > 100{
//            pass = false
//        }
//        return pass
//    }
    
    
    var item: Any
    var body: some View {
        if let result = item as? Midterm
        {
            HStack {
                Text(formatdate(date: result.date))
                Spacer()
                Text(result.name)
                Spacer()
                
                
                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
                    Text("未完成").foregroundColor( .red)
                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
                    Text("進行中")
                }else if result.isCompleted{
                    Text("已完成")
                        .foregroundColor( .green)
                }
                
                //Text("\(Perweight(subject: subject))")
                
                if appState.predictmode == 0{
                    if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                        
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).result / (Perweight(subject: subject)).total / 100))) 分").frame(width: 60)
                         
                    }
                }else if appState.predictmode == 1{
                    if Perweight(subject: subject).k * result.weight > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                         
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).k * result.weight))) 分").frame(width: 60)
                        
                    }
                }
                Text("佔比：")
                Text( "\(Int(result.weight))%").frame(width: 45)
                
            }
        }else if let result = item as? Final {
            HStack {
                Text(formatdate(date: result.date))
                Spacer()
                Text(result.name)
                Spacer()
                
                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
                    Text("未完成").foregroundColor( .red)
                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
                    Text("進行中")
                }else if result.isCompleted{
                    Text("已完成")
                        .foregroundColor( .green)
                }
                
                if appState.predictmode == 0{
                    if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                         
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).result / (Perweight(subject: subject).total / 100)))) 分").frame(width: 60)
                         
                    }
                }else if appState.predictmode == 1{
                    if Perweight(subject: subject).k * result.weight > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                        
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).k * result.weight))) 分").frame(width: 60)
                         
                    }
                }
                
                Text("佔比：")
                Text( "\(Int(result.weight))%").frame(width: 45)
            }
        }else if let result = item as? Quiz {
            HStack {
                Text(formatdate(date: result.date))
                Spacer()
                Text(result.name)
                Spacer()
                
                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
                    Text("未完成").foregroundColor( .red)
                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
                    Text("進行中")
                }else if result.isCompleted{
                    Text("已完成")
                        .foregroundColor( .green)
                }
                
                if appState.predictmode == 0{
                    if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                         
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).result / (Perweight(subject: subject).total / 100)))) 分").frame(width: 60)
                         
                    }
                }else if appState.predictmode == 1{
                    if Perweight(subject: subject).k * result.weight > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                       
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).k * result.weight))) 分").frame(width: 60)
                       
                    }
                }
                
                Text("佔比：")
                Text( "\(Int(result.weight))%").frame(width: 45)
            }
        }
        else if let result = item as? Assignment {
            HStack {
                Text(formatdate(date: result.date))
                Spacer()
                Text(result.name)
                Spacer()
                
                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
                    Text("未完成").foregroundColor( .red)
                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
                    Text("進行中")
                }else if result.isCompleted{
                    Text("已完成")
                        .foregroundColor( .green)
                }
                
                if appState.predictmode == 0{
                    if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                         
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).result / (Perweight(subject: subject).total / 100)))) 分").frame(width: 60)
                        
                    }
                }else if appState.predictmode == 1{
                    if Perweight(subject: subject).k * result.weight > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                         
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).k * result.weight))) 分").frame(width: 60)
                         
                    }
                }
                
                Text("佔比：")
                Text( "\(Int(result.weight))%").frame(width: 45)
            }
        }
        else if let result = item as? Other{
            HStack {
                Text(formatdate(date: result.date))
                Spacer()
                Text(result.name)
                Spacer()
                
                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
                    Text("未完成").foregroundColor( .red)
                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
                    Text("進行中")
                }else if result.isCompleted{
                    Text("已完成")
                        .foregroundColor( .green)
                }
                
                if appState.predictmode == 0{
                    if Perweight(subject: subject).result / (Perweight(subject: subject).total / 100) > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                       
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).result / (Perweight(subject: subject).total / 100)))) 分").frame(width: 60)
                     
                    }
                }else if appState.predictmode == 1{
                    if Perweight(subject: subject).k * result.weight > 100 {
                        Text(">100分").foregroundColor(.red).frame(width: 60)
                      
                    }else{
                        Text("\(Int(ceil(Perweight(subject: subject).k * result.weight))) 分").frame(width: 60)
                         
                    }
                }
                
                Text("佔比：")
                Text( "\(Int(result.weight))%").frame(width: 45)
            }
        }

    }

}
