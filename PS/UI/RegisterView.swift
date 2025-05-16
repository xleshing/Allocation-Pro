import SwiftUI
import SwiftData

struct RegisterView: View {
    @EnvironmentObject var appState: AppState // 接收環境對象
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @Environment(\.modelContext) private var context // SwiftData 上下文
    @State private var account: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationMessage: String?
    
    
    private func fetchUsers(account: String) -> Bool{
        let predicate = #Predicate<User> { $0.account == account}
        let fetchDescriptor = FetchDescriptor<User>(predicate: predicate)
        do {
            let result = try context.fetch(fetchDescriptor)
            if result.isEmpty {
                return false
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return true
    }
    
    private func register(account: String, password: String, confirmPassword: String) -> (registrationMessage: String, pass: Bool) {
        // 預設值
        var registrationMessage = ""
        var pass = false

        // 驗證帳號格式是否正確
        guard account.contains("@thu.edu.tw") else {
            registrationMessage = "帳號格式錯誤，必須包含 @thu.edu.tw"
            return (registrationMessage, pass)
        }

        do {
            if !(password == confirmPassword){
                registrationMessage = "密碼與確認密碼不符"
                return (registrationMessage, pass)
            }
            // 檢查帳號是否已存在
            if fetchUsers(account: account) {
                registrationMessage = "帳號已存在"
                return (registrationMessage, pass)
            }
            
            // 創建新用戶並儲存
            let newUser = User(account: account, password: password)
            context.insert(newUser)
            pass = true
            registrationMessage = "註冊成功！"
            return (registrationMessage, pass)
            
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("註冊帳號").font(.title).bold()
            
            TextField("輸入帳號 (例如 xxx@thu.edu.tw)", text: $account)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
            SecureField("輸入密碼", text: $password)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
            SecureField("確認密碼", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
            
            Button("註冊") {
                let result = register(account: account, password: password, confirmPassword: confirmPassword)
                registrationMessage = result.registrationMessage

                if result.pass {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 暫停 1 秒
                        dismiss()
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            if let message = registrationMessage {
                Text(message).foregroundColor(message == "註冊成功！" ? .green : .red)
            }
            
            Button("取消") {
                dismiss()
            }
            .font(.footnote)
            .padding(.top, 8)
        }
        .padding()
    }
}
