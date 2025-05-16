import SwiftUI
import SwiftData

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @State private var account: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isRegistering: Bool = false // 用於控制是否顯示註冊視圖
    
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
        VStack {
            Text("登入").font(.title).bold()
                        
            TextField("輸入帳號", text: $account)
                .textFieldStyle(.roundedBorder)
            SecureField("輸入密碼", text: $password)
                .textFieldStyle(.roundedBorder)
            
            
            if let error = errorMessage {
                Text(error).foregroundColor(error == "登錄成功" ? .green : .red)
            }
            
            
            Button(action: {
                // 傳遞 context 作為 login 方法的參數
                if !login(account: account, password: password).pass {
                    errorMessage = "帳號或密碼錯誤"
                }else{
                    appState.login(account: account)
                    errorMessage = "登錄成功"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
            }){
                Text("登入")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            
            // 註冊按鈕
            Button("沒有帳號？註冊一個") {
                isRegistering = true // 切換到註冊模式
            }
            .font(.footnote)
            .padding(8)
        }
        .padding()
        // 顯示註冊視圖
        .sheet(isPresented: $isRegistering) {
            RegisterView().environment(\.modelContext, context)
        }
    }
}

