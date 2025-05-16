import SwiftUI
import SwiftData

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: String = ""
    @Published var predictmode: Int = 0 //0代表平均模式，1代表權重模式
    @Published var isFirstLaunch: Bool = true
    
    init() {
        checkLoginStatus() // 應用啟動時檢查狀態
        checkLoginUser()
        checkpredictmode()
        //checkisFirstLaunch()
        }
    
    func checkisFirstLaunch() {
        isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    }
    
    func changeisFirstLaunch() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch") // 保存predictmode狀態
    }
    
    func checkLoginUser() {
        if isLoggedIn{
            user = UserDefaults.standard.string(forKey: "isLoggedInAccount") ?? ""
            }
        }
    
    func checkpredictmode() {
        // 從 UserDefaults 檢查 Predictmode
        predictmode = UserDefaults.standard.integer(forKey: "predictmode")
    }
    
    func changepredictmode(mode: Int) {
        UserDefaults.standard.set(mode, forKey: "predictmode") // 保存predictmode狀態
    }
    
    func checkLoginStatus() {
        // 從 UserDefaults 檢查是否已登入
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login(account: String) {
        isLoggedIn = true
        user = account
        UserDefaults.standard.set(true, forKey: "isLoggedIn") // 保存登錄狀態
        UserDefaults.standard.set(account, forKey: "isLoggedInAccount")
        }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn") // 清除登錄狀態
    }
    
    func WithinDays(from date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 計算兩個日期之間的天數
        if let daysDifference = calendar.dateComponents([.day], from: currentDate, to: date).day {
            return daysDifference
        }
        return -1
    }
    
    func resetCoreData() {
        let fileManager = FileManager.default
        guard let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("default.store") else {
            print("Failed to locate Core Data store")
            return
        }
        
        do {
            if fileManager.fileExists(atPath: storeURL.path) {
                try fileManager.removeItem(at: storeURL)
                print("Core Data store successfully reset")
            }
        } catch {
            print("Failed to reset Core Data store: \(error.localizedDescription)")
        }
    }


}

//
////
////  Gradedetail.swift
////  PS
////
////  Created by 劉家弘 on 2024/11/27.
////
//
//import SwiftUI
//import SwiftData
//import Foundation
//
//struct SubjectDetalView: View {
//    @EnvironmentObject var appState: AppState
//    @Environment(\.modelContext) private var context
//    @State private var isAdding: Bool = false
//    @State private var selectedExamType: String = "期中" // 預設選擇「期中」
//    @State private var refreshID = UUID()
//    var subject: Subject
//    
//    func calculateAverage() -> String {
//        var totalScore = 0.0
//
//        for midterm in subject.midterms {
//            totalScore += (midterm.score ?? 0) * midterm.weight / 100
//        }
//
//        for final in subject.finals {
//            totalScore += (final.score ?? 0) * final.weight / 100
//        }
//
//        for quiz in subject.quizzes {
//            totalScore += (quiz.score ?? 0) * quiz.weight / 100
//        }
//
//        for other in subject.others {
//            totalScore += (other.score ?? 0) * other.weight / 100
//        }
//
//        for assignment in subject.assignments {
//            totalScore += (assignment.score ?? 0) * assignment.weight / 100
//        }
//
//        return totalScore / (subject.targetscore - subject.bonusscore) * 100 < 100 ? String(format: "%.1f", totalScore / (subject.targetscore - subject.bonusscore) * 100) : "100"
//    }
//    
//    
//    
//    var body: some View {
//        NavigationStack{
//            VStack {
//                Spacer()
//                ZStack{
//                    // 卡片頭部
//                    HStack(alignment: .center) {
//                        // 平均分數
//                        Text(calculateAverage() == "0.0" ? "-.-" : calculateAverage())
//                            .font(.title)
//                            .bold()
//                            .frame(width: 75, height: 100)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(12)
//                        
//                        Spacer().frame(width: 30)
//                        
//                        VStack(alignment: .leading) {
//                            Text(subject.name)
//                                .font(.largeTitle)
//                                .bold()
//                        }
//                        
//                        Spacer()
//                    }
//                    .frame(width: 345, height: 100)
//                    .padding()
//                    .cornerRadius(12)
//                    
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(lineWidth: 5)
//                        .opacity(0.2)
//                        .foregroundColor(.gray)
//                        .frame(width: 380, height: 135)
//                    
//                    // 進度條
//                    RoundedRectangle(cornerRadius: 12)
//                        .trim(from: 0.0, to: Double(calculateAverage())! / 100) // 進度百分比
//                        .stroke(Color(red: 0.3, green: 0.8, blue: 0.8),
//                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
//                        )
//                        .rotationEffect(Angle(degrees: -180))
//                        .frame(width: 380, height: 135)
//                }.padding()
//                
//                
//                HStack {
//                    Spacer()
//                    ForEach(["期中", "期末", "作業", "小考", "其他"], id: \.self) { type in
//                        Text(type)
//                            .font(.subheadline)
//                            .foregroundColor(selectedExamType == type ? .white : .primary)
//                            .padding(10)
//                            .background(
//                                selectedExamType == type ? Color.blue : Color.clear
//                            )
//                            .cornerRadius(12)
//                            .onTapGesture {
//                                selectedExamType = type // 更新選擇的考試類型
//                            }
//                    }
//                    Spacer()
//                }
//                
//
//                
//                // 動態顯示選擇的類型數據
//                if let items = getSelectedItems() as? [Midterm] {
//                    SectionView(
//                        subject: subject,
//                        title: "\(selectedExamType)資訊",
//                        allItems: items)
//                }else if let items = getSelectedItems() as? [Final] {
//                    SectionView(
//                        subject: subject,
//                        title: "\(selectedExamType)資訊",
//                        allItems: items)
//                }else if let items = getSelectedItems() as? [Quiz] {
//                    SectionView(
//                        subject: subject,
//                        title: "\(selectedExamType)資訊",
//                        allItems: items)
//                }else if let items = getSelectedItems() as? [Assignment] {
//                    SectionView(
//                        subject: subject,
//                        title: "\(selectedExamType)資訊",
//                        allItems: items)
//                }else if let items = getSelectedItems() as? [Other] {
//                    SectionView(
//                        subject: subject,
//                        title: "\(selectedExamType)資訊",
//                        allItems: items)
//                } else {
//                    Text("沒有相關數據")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                
//                // 右下角新增按钮
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            isAdding = true
//                        }) {
//                            Image(systemName: "plus")
//                                .font(.system(size: 24))
//                                .padding()
//                        }
//                        .padding()
//                        .sheet(isPresented: $isAdding) {
//                            AddItemView(selectedExamType:selectedExamType, subject:subject) // 替换为你的新增页面
//                        }
//                    }
//                }
//                
//            }
//        }.id(refreshID) // 强制刷新
//    }
//    
//    /// 根據選擇的類型返回對應數據
//    func getSelectedItems() -> [Any]? {
//        switch selectedExamType {
//        case "期中":
//            return subject.midterms
//        case "期末":
//            return subject.finals
//        case "作業":
//            return subject.assignments
//        case "小考":
//            return subject.quizzes
//        case "其他":
//            return subject.others
//        default:
//            return nil
//        }
//    }
//    
//
//}
//    
//
//// 顯示數據的視圖
//struct SectionView<Item: Identifiable>: View {
//    @Environment(\.modelContext) private var context
//    @State private var items: [Item] = [] // 使用 @State 数组管理数据
//    @State private var editingItem: Item? // 当前编辑的对象
//    var subject: Subject
//    let title: String
//    let allItems: [Item] // 原始数据来源
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text(title)
//                .font(.headline)
//                .bold()
//            List {
//                ForEach(items) { item in
//                    RowView(item: item)
//                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                            Button(role: .destructive) {
//                                deleteItem(item: item)
//                            } label: {
//                                Label("刪除", systemImage: "trash")
//                            }
//                        }
//                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                            Button {
//                                editingItem = item // 设置当前正在编辑的对象
//                            } label: {
//                                Label("編輯", systemImage: "pencil")
//                            }
//                            .tint(.blue)
//                        }
//                }
//            }
//            .scrollContentBackground(.hidden)
//            .onAppear {
//                loadItems()
//                
//            }
//        }
//        .sheet(item: $editingItem) { item in
//            EditItemView(item: item)
//        }
//    }
//
//    /// 加载数据到 @State 数组
//    private func loadItems() {
//        items = allItems // 将传入的所有数据加载到 @State 数组
//    }
//
//    /// 删除数据的方法
//    private func deleteItem(item: Item) {
//        // 从 items 中移除该项
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items.remove(at: index)
//        }
//
//        // 删除操作同步到 context
//        if let result = item as? Midterm {
//            context.delete(result)
//        } else if let result = item as? Final {
//            context.delete(result)
//        } else if let result = item as? Quiz {
//            context.delete(result)
//        } else if let result = item as? Assignment {
//            context.delete(result)
//        } else if let result = item as? Other {
//            context.delete(result)
//        }
//    }
//}
//
//
//
//// 不同類型的視圖
//struct RowView: View {
//    @EnvironmentObject var appState: AppState
//    @Environment(\.modelContext) private var context
//    
//    func formatdate(date: Date) -> String{
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        return formatter.string(from: date)
//    }
//    
//    
//    var item: Any
//    var body: some View {
//        if let result = item as? Midterm
//        {
//            HStack {
//                Text(formatdate(date: result.date))
//                Spacer()
//                Text(result.name)
//                Spacer()
//                
//                
//                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
//                    Text("未完成").foregroundColor( .red)
//                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
//                    Text("進行中")
//                }else if result.isCompleted{
//                    Text("已完成")
//                        .foregroundColor( .green)
//                }
//                if result.score == nil{
//                    Text("-").frame(width: 60)
//                }else if Int(result.score ?? 0) < 60 {
//                    Text("\(Int(result.score ?? 0)) 分").foregroundColor(.red).frame(width: 60)
//                }else{
//                    Text("\(Int(result.score ?? 0)) 分").frame(width: 60)
//                }
//                Text("佔比：")
//                Text( "\(Int(result.weight))%").frame(width: 45)
//                
//            }
//        }else if let result = item as? Final {
//            HStack {
//                Text(formatdate(date: result.date))
//                Spacer()
//                Text(result.name)
//                Spacer()
//                
//                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
//                    Text("未完成").foregroundColor( .red)
//                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
//                    Text("進行中")
//                }else if result.isCompleted{
//                    Text("已完成")
//                        .foregroundColor( .green)
//                }
//                
//                if result.score == nil{
//                    Text("-").frame(width: 60)
//                }else if Int(result.score ?? 0) < 60 {
//                    Text("\(Int(result.score ?? 0)) 分").foregroundColor(.red).frame(width: 60)
//                }else{
//                    Text("\(Int(result.score ?? 0)) 分").frame(width: 60)
//                }
//                
//                Text("佔比：")
//                Text( "\(Int(result.weight))%").frame(width: 45)
//            }
//        }else if let result = item as? Quiz {
//            HStack {
//                Text(formatdate(date: result.date))
//                Spacer()
//                Text(result.name)
//                Spacer()
//                
//                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
//                    Text("未完成").foregroundColor( .red)
//                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
//                    Text("進行中")
//                }else if result.isCompleted{
//                    Text("已完成")
//                        .foregroundColor( .green)
//                }
//                
//                if result.score == nil{
//                    Text("-").frame(width: 60)
//                }else if Int(result.score ?? 0) < 60 {
//                    Text("\(Int(result.score ?? 0)) 分").foregroundColor(.red).frame(width: 60)
//                }else{
//                    Text("\(Int(result.score ?? 0)) 分").frame(width: 60)
//                }
//                
//                Text("佔比：")
//                Text( "\(Int(result.weight))%").frame(width: 45)
//            }
//        }
//        else if let result = item as? Assignment {
//            HStack {
//                Text(formatdate(date: result.date))
//                Spacer()
//                Text(result.name)
//                Spacer()
//                
//                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
//                    Text("未完成").foregroundColor( .red)
//                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
//                    Text("進行中")
//                }else if result.isCompleted{
//                    Text("已完成")
//                        .foregroundColor( .green)
//                }
//                
//                if result.score == nil{
//                    Text("-").frame(width: 60)
//                }else if Int(result.score ?? 0) < 60 {
//                    Text("\(Int(result.score ?? 0)) 分").foregroundColor(.red).frame(width: 60)
//                }else{
//                    Text("\(Int(result.score ?? 0)) 分").frame(width: 60)
//                }
//                
//                Text("佔比：")
//                Text( "\(Int(result.weight))%").frame(width: 45)
//            }
//        }
//        else if let result = item as? Other{
//            HStack {
//                Text(formatdate(date: result.date))
//                Spacer()
//                Text(result.name)
//                Spacer()
//                
//                if appState.WithinDays(from: result.date) < 0 && !result.isCompleted{
//                    Text("未完成").foregroundColor( .red)
//                }else if appState.WithinDays(from: result.date) >= 0 && !result.isCompleted{
//                    Text("進行中")
//                }else if result.isCompleted{
//                    Text("已完成")
//                        .foregroundColor( .green)
//                }
//                
//                if result.score == nil{
//                    Text("-").frame(width: 60)
//                }else if Int(result.score ?? 0) < 60 {
//                    Text("\(Int(result.score ?? 0)) 分").foregroundColor(.red).frame(width: 60)
//                }else{
//                    Text("\(Int(result.score ?? 0)) 分").frame(width: 60)
//                }
//                
//                Text("佔比：")
//                Text( "\(Int(result.weight))%").frame(width: 45)
//            }
//        }
//
//    }
//
//}
