//
//  TargetscoreCardView.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/29.
//
import SwiftUI
import SwiftData

struct TargetscoreCardView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    
    var body: some View {
            VStack{
                if let currentUser = fetch(account: appState.user) {
                    List {
                        ForEach(currentUser.subjects){ subject in
                            TargetCardView(subject: subject)
                        }
                    }
                }else{
                    Text("未找到用戶資料")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("目標分數")
            .navigationBarTitleDisplayMode(.inline)
            
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
}

struct TargetCardView: View {
    @State var subject: Subject
    
    var body: some View {
        NavigationStack{
            NavigationLink (destination: EditTargetView(subject:subject)){
                HStack {
                    Text(subject.name)
                    Spacer()
                    Text(String(subject.targetscore))
                        .font(.body)
                        .foregroundColor(.gray)
                    
                }
            }
        }
        .contentShape(Rectangle())
    }
}

