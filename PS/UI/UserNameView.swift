//
//  UserNameView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/7.
//


import SwiftUI

struct UserNameView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入
    @State var showDeleteAccountView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    Section{
                        VStack{
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
                            HStack{
                                Spacer()
                                // 用户名称
                                Text(appState.user.split(separator: "@").first ?? "")
                                    .font(.title)
                                    .bold()
                                    .padding(.top, 8)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                // 用户邮箱
                                Text(appState.user)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }.listRowBackground(Color.clear)  // 隐藏默认背景
                
                // 个人信息列表
                
                    Section(){
                        NavigationLink(destination: UserInfoView()) {
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                    .foregroundColor(.gray)
                                    .frame(width: 30, height: 30)
                                Text("個人資訊")
                                    .font(.body)
                            }
                        }
                        NavigationLink(destination: UserPasswordView()) {
                            HStack {
                                Image(systemName: "key")
                                    .foregroundColor(.gray)
                                    .frame(width: 30, height: 30)
                                Text("登入")
                                    .font(.body)
                            }
                        }
                    }
                    
                    Section(){
                        Button(action: {
                            showDeleteAccountView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("刪除帳戶")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                        
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .sheet(isPresented: $showDeleteAccountView) {
            DeleteAccountView(account: appState.user)
        }
        .navigationTitle("帳號")
        .navigationBarTitleDisplayMode(.inline)
    }
}
