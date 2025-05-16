import SwiftUI
import SwiftData

struct EditItemView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var errorMessage: String?

    let item: Any

    @State private var score: String = "" // 记录当前分数
    @State private var score_nil: Double? // 记录当前分数
    @State private var weight: String = "" // 记录当前权重
    @State private var date: Date = Date() // 记录当前日期
    @State private var name: String = ""
    @State private var isCompleted: Bool = false
    
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                HStack(alignment: .center){
                    Spacer()
                    Text("編輯")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 10) {
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
                        TextField(name, text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .keyboardType(.default)
                        Text("分").opacity(0)
                    }
                    
                    HStack {
                        Text("成績")
                            .font(.subheadline)
                        Spacer()
                        TextField(score, text: $score)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        Text("分")
                    }
                    
                    HStack {
                        Text("佔比")
                            .font(.subheadline)
                        Spacer()
                        TextField(weight, text:$weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        Text("%")
                    }
                    
                    HStack {
                        Toggle(isOn: $isCompleted) {
                            Text(isCompleted ? "已完成" : "未完成")
                            Text("分").opacity(0)
                        }
                    }
                }
                .padding(.horizontal)
                
                if let message = errorMessage {
                    Text(message).foregroundColor(message == "保存成功" ? .green : .red)
                }
                
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    
                    }) {
                        Text("取消").foregroundStyle(Color(.systemRed))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if score == "" {
                            score_nil = nil
                        } else {
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
                        guard weight >= 0 && weight <= 100 else {
                            errorMessage = "佔比應在 0 到 100% 之間"
                            return
                        }

                        errorMessage = save()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            dismiss()
                        }
                    }) {
                        Text("保存").foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
        .navigationTitle("修改")
        .onAppear {
            load()
        }
        
    }

    /// 通用的加载数据方法
    private func load() {
        if let result = item as? Midterm {
            name = result.name
            score = result.score != nil ? String((result.score)!) : ""
            weight = String(result.weight)
            date = result.date
            isCompleted = result.isCompleted
        } else if let result = item as? Final {
            name = result.name
            score = result.score != nil ? String((result.score)!) : ""
            weight = String(result.weight)
            date = result.date
            isCompleted = result.isCompleted
        } else if let result = item as? Quiz {
            name = result.name
            score = result.score != nil ? String((result.score)!) : ""
            weight = String(result.weight)
            date = result.date
            isCompleted = result.isCompleted
        } else if let result = item as? Assignment {
            name = result.name
            score = result.score != nil ? String((result.score)!) : ""
            weight = String(result.weight)
            date = result.date
            isCompleted = result.isCompleted
        } else if let result = item as? Other {
            name = result.name
            score = result.score != nil ? String((result.score)!) : ""
            weight = String(result.weight)
            date = result.date
            isCompleted = result.isCompleted
        }
    }

    /// 通用的保存修改方法
    private func save() -> String {
        if let result = item as? Midterm {
            let newWeight = (result.subject!.calculateTotalWeight() + (Double(weight)!))
            guard newWeight - result.weight <= 100 else {
                return "總佔比超過100%"
            }
            result.name = name
            result.score = score_nil
            result.weight = Double(weight)!
            result.date = date
            result.isCompleted = isCompleted
        } else if let result = item as? Final {
            let newWeight = (result.subject!.calculateTotalWeight() + (Double(weight)!))
            guard newWeight - result.weight <= 100 else {
                return "總佔比超過100%"
            }
            result.name = name
            result.score = score_nil
            result.weight = Double(weight)!
            result.date = date
            result.isCompleted = isCompleted
        } else if let result = item as? Quiz {
            let newWeight = (result.subject!.calculateTotalWeight() + (Double(weight)!))
            guard newWeight - result.weight <= 100 else {
                return "總佔比超過100%"
            }
            result.name = name
            result.score = score_nil
            result.weight = Double(weight)!
            result.date = date
            result.isCompleted = isCompleted
        } else if let result = item as? Assignment {
            let newWeight = (result.subject!.calculateTotalWeight() + (Double(weight)!))
            guard newWeight - result.weight <= 100 else {
                return "總佔比超過100%"
            }
            result.name = name
            result.score = score_nil
            result.weight = Double(weight)!
            result.date = date
            result.isCompleted = isCompleted
        } else if let result = item as? Other {
            let newWeight = (result.subject!.calculateTotalWeight() + (Double(weight)!))
            guard newWeight - result.weight <= 100 else {
                return "總佔比超過100%"
            }
            result.name = name
            result.score = score_nil
            result.weight = Double(weight)!
            result.date = date
            result.isCompleted = isCompleted
        }
        return "保存成功"
    }
}
