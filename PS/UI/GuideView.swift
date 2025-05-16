//
//  GuideView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/9.
//


import SwiftUI
import SwiftData

struct GuideView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    Section(){
                        VStack{
                            HStack{
                                Spacer()
                                Text("關於").bold().font(.title)
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    
                    Section(){
                        VStack{
                            HStack{
                                Spacer()
                                Text("免責聲明").bold().font(.title)
                                Spacer()
                            }.padding()
                            Spacer()
                            Text("如因本服務計算出錯或不正確等各種因素，而造成之事件，本服務既不負責，請自行核查").font(.body)
                            Spacer()
                        }
                    }
                    
                    Section(){
                        VStack{
                            HStack{
                                Spacer()
                                Text("使用條款，隱私條款").bold().font(.title)
                                Spacer()
                            }.padding()
                            Spacer()
                            Text("Allocation Pro (以下簡稱 本服務 ) 規定的服務條款和隱私政策如下。")
                            Spacer()
                            Text("個人資訊的使用").bold()
                            Spacer()
                            Text("使用此服務,我們不會按姓名、出生日期、電子郵件地址和其他描述獲取個人識別資訊。我們使用cookie 獲取資訊, 使用廣告分發服務, 如 google和資料分析服務。這些資訊是基於最佳廣告的分佈和通過分析資料來提高進一步應用的便利性, 我將使用它。")
                            Spacer()
                            Text("個人資訊的協力廠商提供").bold()
                            Spacer()
                            Text("此服務不向協力廠商提供可識別個人身份的資訊。")
                            Spacer()
                            Text("更改使用條款/隱私政策").bold()
                            Spacer()
                            Text("此服務可以更改使用條款和隱私政策, 而無需在必要時事先征得使用者同意。")
                            Spacer()
                            Text("免責聲明").bold()
                            Spacer()
                            Text("開發商對使用者使用本服務造成的損害不承擔責任。")
                            Spacer()
                            Text("※如果您有任何問題, 請聯繫我們。").bold()
                            Text("ycair@gmail.com")
                            Spacer()
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action:{
                        dismiss()
                    }){
                        Text("完成").foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
        .navigationTitle("關於")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
