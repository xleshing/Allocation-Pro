import SwiftUI
import SwiftData

@main
struct AllocationProApp: App {
    @StateObject private var appState = AppState() // 初始化 ObservableObject
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState) // 傳遞到所有子視圖
                .modelContainer(for: [User.self, Subject.self, Assignment.self, Final.self, Midterm.self, Other.self, Quiz.self]) // 初始化 ModelContainer
        }
    }
}
