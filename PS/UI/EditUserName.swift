//
//  EditUserName.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/7.
//
import SwiftUI
import SwiftData


struct EditUserName: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    @State var newaccount:String = ""
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @State private var errorMessage: String?
    
    private func editaccount(account: String) -> (pass:Bool, user: [User]?){
        var pass = false
        var user: [User]?
        let predicate = #Predicate<User> { $0.account == account}
        let fetchDescriptor = FetchDescriptor<User>(predicate: predicate)
        do {
            let result = try context.fetch(fetchDescriptor)
            if result.isEmpty {
                return (pass, user)
            }else{
                user = result
                pass = true
                return (pass, user)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return (pass, user)
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    HStack{
                        //Text("帳號名稱")
                        TextField(appState.user.split(separator: "@").first ?? "", text: $newaccount)
                            .multilineTextAlignment(.leading)
                    }
                }
                Section{
                    HStack{
                        Spacer()
                        if let message = errorMessage {
                            Text(message).foregroundColor(message == "保存成功" ? .green : .red)
                        }
                        Spacer()
                    }
                }.listRowBackground(Color.clear)  // 隐藏默认背景
            }
        }.navigationTitle("帳號名稱")
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 確認按鈕
                    Button(action: {
                        guard !newaccount.isEmpty else {
                            errorMessage = "名稱不可為空"
                            return
                        }
                        guard !editaccount(account: "\(newaccount)@thu.edu.tw").pass else {
                            errorMessage = "帳戶名稱已存在"
                            return
                        }
                        editaccount(account: appState.user).user?.first?.account = "\(newaccount)@thu.edu.tw"
                        errorMessage = "保存成功"
                        appState.logout()
                        appState.login(account: "\(newaccount)@thu.edu.tw")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            dismiss()
                        }
                        
                    }) {
                        Text("完成")
                            .foregroundColor(Color(.systemRed))
                    }
                }
                
            }
    }
}
