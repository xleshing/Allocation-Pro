import SwiftUI
import SwiftData

struct SubjectsView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    @State var showDetal:Subject? = nil
    @Query private var subjects: [Subject]
    @State private var isAddingSubject:Bool = false

    
    var body: some View {
        NavigationStack{
            VStack{
                if let user = fetch(account: appState.user){
                    List {
                        ForEach(user.subjects, id: \.self) { subject in
//                            NavigationLink(destination:  SubjectDetalView(subject: subject)){
//                                SubjectCardView(subject: subject)
//                            }
                            SubjectCardView(subject: subject)
                                .onTapGesture {
                                    showDetal = subject // 設置當前選中對象
                                    
                                }
                            
                        }
                        .onDelete { indexSet in
                            deleteSubjects(at: indexSet)
                        }
                    }
                }else{
                    Text("未登錄")
                }
            }
        }
        .navigationTitle("科目")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .sheet(item: $showDetal) { subject in
            SubjectDetalView(subject: subject) // 根據選中的對象顯示對應的編輯視圖
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAddingSubject = true
                } label: {
                    Image(systemName: "plus") // 新增按鈕圖示
                }
                }
        }
        .sheet(isPresented: $isAddingSubject) {
            AddSubjectView ().environment(\.modelContext, context)
        }
        
    }
    
    private func fetch(account: String) -> User?{
        var result: User?
        let predicate = #Predicate<User> { $0.account == account}
        let fetchDescriptor = FetchDescriptor<User>(predicate: predicate)
        do {
            result = try context.fetch(fetchDescriptor).first
        } catch {
            print("Error fetching data: \(error)")
        }
        return result
    }
    
    private func deleteSubjects(at offsets: IndexSet) {
        DispatchQueue.main.async {
            for index in offsets {
                let subject = subjects[index]
                context.delete(subject) // 刪除對應的 Subject
            }
            do {
                try context.save() // 保存刪除後的狀態
            } catch {
                print("Failed to delete subjects: \(error)")
            }
        }
    }
}
