//
//  AddingSubjectView.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/27.
//



import SwiftUI
import SwiftData

struct AddSubjectView: View {
    @EnvironmentObject var appState: AppState // 確保 AppState 已被正確注入
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @Environment(\.modelContext) private var context
    @State var name: String = ""
    @State var errormessage:String?

    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                Spacer()
                Text("科目名稱")
                    .font(.title)
                HStack {
                    TextField("輸入", text: $name)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 100)
                        .font(.title3)
                        .keyboardType(.default)
                }
                if let error = errormessage{
                    Text(error).foregroundColor(error == "保存成功" ? .green : .red)
                }
                
                Spacer()
                
            }.toolbar
            {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    
                    }) {
                        Text("取消").foregroundStyle(Color(.systemRed))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 確認按鈕
                    Button(action: {
                        if let user = fetch(account: appState.user){
                            let result = user.subjects.filter { $0.name == name }
                            guard !name.isEmpty else {
                                errormessage = "名稱不可為空"
                                return
                            }
                            guard result.isEmpty else {
                                errormessage = "科目已存在"
                                return
                            }

                            let newsubject = Subject(name: name, user: user)
                            context.insert(newsubject)

                            do {
                                try context.save()
                                errormessage = "保存成功"
                                name = "" // 清空名稱以避免重複檢查
                            } catch {
                                errormessage = "保存失敗：\(error.localizedDescription)"
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                dismiss()
                            }
                        }
                    }) {
                        Text("加入")
                            .foregroundColor(Color(.systemRed))
                    }
                }
                
            }
        }
        .padding()
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

struct AddingSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubjectView()
    }
}
