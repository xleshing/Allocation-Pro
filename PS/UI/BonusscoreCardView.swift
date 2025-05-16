//
//  BonusscoreCardView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/8.
//

import SwiftUI
import SwiftData

struct BonusscoreCardView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    
    var body: some View {
            VStack{
                if let currentUser = fetch(account: appState.user) {
                    List {
                        ForEach(currentUser.subjects){ subject in
                            BonusCardView(subject: subject)
                        }
                    }
                }else{
                    Text("未找到用戶資料")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("額外加分")
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

struct BonusCardView: View {
    @State var subject: Subject
    
    var body: some View {
        NavigationStack{
            NavigationLink (destination: EditBonusView(subject:subject)){
                HStack {
                    Text(subject.name)
                    Spacer()
                    Text(String(subject.bonusscore))
                        .font(.body)
                        .foregroundColor(.gray)
                    
                }
            }
        }
        .contentShape(Rectangle())
    }
}

