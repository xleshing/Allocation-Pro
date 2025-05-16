import SwiftUI
import SwiftData



struct DeleteAccountView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    @Environment(\.modelContext) private var context
    @State var password:String = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    var account:String
    
    private func login(account: String, password: String) -> (pass:Bool, user: [User]?){
        var pass = false
        var user: [User]?
        let predicate = #Predicate<User> { $0.account == account && $0.password == password }
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
            VStack {
                SecureField("輸入密碼", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                
                if let error = errorMessage {
                    Text(error).foregroundColor(error == "刪除成功，請重新登錄" ? .green : .red)
                }
                
                Spacer()
                
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if !login(account: account, password: password).pass {
                            errorMessage = "密碼錯誤"
                        }else{
                            context.delete(login(account: account, password: password).user?.first ?? User(account: "", password: ""))
                            errorMessage = "刪除成功，請重新登錄"
                            appState.logout()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                dismiss()
                            }
                        }
                    }){
                        Text("完成")
                            .foregroundColor(.red)
                    }
                }
            }
                    
        }
        .padding()
    }
}
