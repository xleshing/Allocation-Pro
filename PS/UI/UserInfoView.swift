//
//  PersonalInfoView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/7.
//
import SwiftUI
import SwiftData



struct UserInfoView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    
    var body: some View {
        NavigationStack {
            List {
                Section{
                    HStack{
                        Spacer()
                        // 用户头像
                        Image(systemName: "person.circle.fill") // 替换为用户头像图片
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray) // 设置头像颜色
                            .padding(.top, 20)
                        Spacer()
                    }
//                    HStack{
//                        Spacer()
//                        NavigationLink(destination: EditUserImage())
//                        {
//                            HStack {
//                                Text("編輯")
//                                    .font(.body)
//                                    .bold()
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
                }.listRowBackground(Color.clear)  // 隐藏默认背景
                
                Section{
                // 个人信息列表
                    NavigationLink(destination: EditUserName()) {
                        HStack {
                            Text("帳號名稱")
                                .font(.body)
                            Spacer()
                            
                            Text(appState.user.split(separator: "@").first ?? "")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                        }
                    }
                }
                
                
            }.listStyle(.insetGrouped)
        }
        .navigationTitle("個人資訊")
    }
}
