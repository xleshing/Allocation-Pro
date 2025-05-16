//
//  PasswordView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/8.
//

import SwiftUI
import SwiftData

struct UserPasswordView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    Section(){
                        
                        NavigationLink(destination: EditUserPasswordView())
                        {
                            HStack {
                                Text("更改密碼")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                        }
                    
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("登入")
    }
}
