import SwiftUI
import SwiftData

struct EditUserPasswordView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @State private var oldpassword: String = ""
    @State private var newpassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    
    private func editpassword(account: String, password: String) -> (pass:Bool, user: [User]?){
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
            List{
                Section{
                    SecureField("輸入舊密碼", text: $oldpassword).multilineTextAlignment(.leading)
                    SecureField("輸入新密碼", text: $newpassword).multilineTextAlignment(.leading)
                    SecureField("確認密碼", text: $confirmPassword).multilineTextAlignment(.leading)
                }
                
                Section{
                    HStack{
                        Spacer()
                        if let error = errorMessage {
                            Text(error).foregroundColor(error == "更改成功" ? .green : .red)
                        }
                        Spacer()
                    }
                }.listRowBackground(Color.clear)  // 隐藏默认背景
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        // 傳遞 context 作為 login 方法的參數
                        if newpassword.isEmpty{
                            errorMessage = "密碼不可為空"
                        }else if confirmPassword != newpassword{
                            errorMessage = "密碼與確認密碼不符"
                        }else if !editpassword(account: appState.user, password: oldpassword).pass{
                            errorMessage = "舊密碼錯誤"
                        }else{
                            editpassword(account: appState.user, password: oldpassword).user?.first?.password = newpassword
                            errorMessage = "更改成功"
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
        .navigationTitle("更改密碼")
    }
}




