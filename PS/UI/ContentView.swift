import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var assignments: [Assignment] // 從資料庫中查詢所有作業
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState // 確保 AppState 已被正確注入
    @Environment(\.modelContext) private var context
    @State private var showLoginSheet: Bool = false // 控制是否顯示 LoginView 的狀態
    @State private var alertMessage: String = ""
    @State private var isPresented = false
    @State private var showGuide = false
    
    func WithinDays(from date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // 計算兩個日期之間的天數
        if let daysDifference = calendar.dateComponents([.day], from: currentDate, to: date).day {
            return daysDifference
        }
        return -1
    }
    
    func closestAssignment() -> Assignment? {
        let closestAssignment = assignments
            .map { ($0, days: WithinDays(from: $0.date)) } // 計算日期差並存儲
            .filter { $0.days <= 3 && $0.days >= 0 } // 篩選三天內的作業
            .min { abs($0.0.date.timeIntervalSinceNow) < abs($1.0.date.timeIntervalSinceNow) } // 找最近的作業

        return closestAssignment?.0
    }
    
    func showalert() {
        if closestAssignment() != nil && !(closestAssignment()?.isCompleted ?? true){
            let alertassignment = closestAssignment()
            let alertmassignmentsubject = alertassignment?.subject
            if WithinDays(from: alertassignment!.date) != 0{
                alertMessage = "\(alertmassignmentsubject!.name)作業\(WithinDays(from: alertassignment!.date))天內到期 "
            }else{
                    alertMessage = "\(alertmassignmentsubject!.name)作業今天內到期 "
                }
        }else{
            alertMessage = ""
        }
    }
    
    func checkguide(){
        if appState.isFirstLaunch{
            showGuide = appState.isFirstLaunch
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                // 頂部導航欄
                HStack {
                    NavigationLink(destination: OptionUIView(showlogin: $showLoginSheet)) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .gray : .black) // 根据模式设置颜色
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: UserUIView(showlogin: $showLoginSheet)) {
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .gray : .black) // 根据模式设置颜色
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // App 標題和圖標
                VStack(spacing: 8) {
                    Text("Allocation Pro")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("V1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if appState.isLoggedIn {
                        NavigationLink(destination: SubjectsView()) {
                            Image(systemName: "circle.dashed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            showLoginSheet = true // 顯示登入視圖
                        }) {
                            Image(systemName: "circle.dashed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("By JIA HONG LIU")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack{
                    if alertMessage != ""{
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text("\(String(describing: alertMessage))")
                            .font(.callout)
                            .padding(.vertical, 10)
                    }
                }
                
                
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow.opacity(0.2)))
                .padding(.bottom, 20)
        }
            .environment(\.modelContext, context)
            //.background(Color.white.ignoresSafeArea()) // 背景色
            .sheet(isPresented: $showLoginSheet) { LoginView()}
            .sheet(isPresented: $showGuide) { GuideView()}
        }
        .navigationTitle("首頁")
        .onChange(of: assignments.map { $0.isCompleted }) {
            showalert()
        }

        .onChange(of: assignments.map { $0.date }) {
            showalert()
        }
        .onChange(of: assignments){
            showalert()
        }
        .onAppear {
            
            checkguide()
            showalert()
            
        }
        
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if appState.isLoggedIn {
            SubjectsView()
        }else{
            Text("請先登入以查看成績")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AppState()) // 使用 environmentObject 傳遞 AppState
}
