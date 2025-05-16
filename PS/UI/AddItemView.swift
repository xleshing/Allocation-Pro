

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var appState: AppState // 確保 AppState 已被正確注入
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @Environment(\.modelContext) private var context
    @State var selectedExamType: String
    @State private var score: String = ""
    @State private var weight: String = ""
    @State private var name: String = ""
    @State private var date = Date()
    @State private var errorMessage: String?
    @State var score_nil:Double?

    let subject: Subject

    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                // 頂部科目名稱和分數
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(subject.name)") // 科目名稱
                            .font(.title)
                            .bold()
                    }
                }
                .padding()
                
                Divider()
                
                // 考試類型標籤
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(["期中", "期末", "作業", "小考", "其他"], id: \.self) { type in
                            Text(type)
                                .font(.subheadline)
                                .foregroundColor(selectedExamType == type ? .white : .primary)
                                .padding(10)
                                .background(
                                    selectedExamType == type ? Color.blue : Color.clear
                                )
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedExamType = type // 更新選擇的考試類型
                                    score = ""
                                    weight = ""
                                    name = ""
                                    
                                }
                        }
                    }
                }
                .padding(.horizontal)
                
                // 成績和佔比輸入區域
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("日期")
                            .font(.subheadline)
                        Spacer()
                        DatePicker(
                            "選擇日期",
                            selection: $date,
                            displayedComponents: [.date] // 僅顯示日期部分
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        Text("分a").opacity(0)
                    }
                    HStack {
                        Text("名稱")
                            .font(.subheadline)
                        Spacer()
                        TextField("輸入名稱", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .keyboardType(.default)
                        Text("分").opacity(0)
                    }
                    
                    HStack {
                        Text("成績")
                            .font(.subheadline)
                        Spacer()
                        TextField("輸入成績", text: $score)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        Text("分")
                    }
                    
                    HStack {
                        Text("佔比")
                            .font(.subheadline)
                        Spacer()
                        TextField("輸入佔比", text:$weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        Text("%")
                    }
                }
                .padding(.horizontal)
                if let message = errorMessage {
                    Text(message).foregroundColor(message == "保存成功" ? .green : .red)
                }
                
                Spacer()
                
            
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    
                    }) {
                        Text("取消").foregroundStyle(Color(.systemRed))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 確認按鈕
                    Button(action: {
                        if score == ""{
                            score_nil = nil
                        }else{
                            score_nil = Double(score)
                        }
                        
                        guard let weight = Double(weight) else {
                            errorMessage = "請輸入有效的佔比"
                            return
                        }
                        
                        // 驗證數據合法性
                        guard score_nil ?? 0 >= 0 && score_nil ?? 0 <= 100 else {
                            errorMessage = "成績應在 0 到 100 之間"
                            return
                        }
                        guard Double(weight) >= 0 && Double(weight) <= 100 else {
                            errorMessage = "佔比應在 0 到 100% 之間"
                            return
                        }
                        
                        // 根據考試類型保存數據
                        switch selectedExamType {
                        case "期中":
                            let newWeight = subject.calculateTotalWeight() + Double(weight)
                            guard newWeight <= 100 else{
                                errorMessage = "總佔比超過100%"
                                return
                            }
                            let newMidterm = Midterm(name:name, date: date, score: score_nil, weight: Double(weight), subject: subject)
                            context.insert(newMidterm)
                            errorMessage = "保存成功"
                            
                        case "期末":
                            let newWeight = subject.calculateTotalWeight() + Double(weight)
                            guard newWeight <= 100 else{
                                errorMessage = "總佔比超過100%"
                                return
                            }
                            let newFinal = Final(name:name, date: date, score: score_nil, weight: Double(weight), subject: subject)
                            context.insert(newFinal)
                            errorMessage = "保存成功"
                            
                            
                        case "小考":
                            let newWeight = subject.calculateTotalWeight() + Double(weight)
                            guard newWeight <= 100 else{
                                errorMessage = "總佔比超過100%"
                                return
                            }
                            let newQuiz = Quiz(name:name, date: date, score: score_nil, weight: Double(weight), subject: subject)
                            context.insert(newQuiz)
                            errorMessage = "保存成功"
                            
                            
                            
                        case "作業":
                            let newWeight = subject.calculateTotalWeight() + Double(weight)
                            guard newWeight <= 100 else{
                                errorMessage = "總佔比超過100%"
                                return
                            }
                            let newAssignment = Assignment(name: name, date: date, score: score_nil, weight: Double(weight), subject: subject)
                            context.insert(newAssignment)
                            errorMessage = "保存成功"
                            
                            
                        case "其他":
                            let newWeight = subject.calculateTotalWeight() + Double(weight)
                            guard newWeight <= 100 else{
                                errorMessage = "總佔比超過100%"
                                return
                            }
                            let newOther = Other(name:name, date: date, score: score_nil, weight: Double(weight), subject: subject)
                            context.insert(newOther)
                            errorMessage = "保存成功"
                            
                            
                        default:
                            print("未知的考試類型")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            dismiss()
                        }
                    }) {
                        Text("加入").foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
        .padding()
        
    }
}
