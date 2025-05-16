import SwiftUI
import SwiftData

struct UserUIView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    @Environment(\.dismiss) private var dismiss // 用于关闭当前视图
    @Binding var showlogin: Bool

    var body: some View {
        NavigationStack {
            VStack {
                
                if appState.isLoggedIn{
                    List {
                        Section(){
                            NavigationLink(destination: UserNameView()) {
                                HStack {
                                    // 头像
                                    Image(systemName:"person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .foregroundColor(.gray) // 设置头像颜色
                                    Text(appState.user.split(separator: "@").first ?? "")
                                        .font(.body)
                                        .bold()
                                    
                                }
                            }
                        }
                        
                        
                        Section(){
                            // 登出按钮作为列表最后一项
                            Button(action: {
                                if !appState.isLoggedIn {
                                    dismiss()
                                    showlogin = true
                                }else{
                                    appState.logout()
                                    dismiss()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(appState.isLoggedIn ? "登出" : "登入")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }.listStyle(.insetGrouped)
                }else{
                    List{
                        Section(){
                            // 登出按钮作为列表最后一项
                            Button(action: {
                                if !appState.isLoggedIn {
                                    dismiss()
                                    showlogin = true
                                }else{
                                    appState.logout()
                                    dismiss()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(appState.isLoggedIn ? "登出" : "登入")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("使用者設定")
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

struct OtherView: View {
    var body: some View {
        Text("其他視圖")
            .font(.headline)
            .padding()
    }
}
