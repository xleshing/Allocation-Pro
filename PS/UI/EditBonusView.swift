//
//  EditBonusscoreView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/8.
//

import SwiftUI
import SwiftData

struct EditBonusView: View {
    let subject: Subject
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @State private var errorMessage: String?
    @State private var score: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    HStack{
                        //Text("\(subject.name)額外加分")
                        TextField(String(subject.bonusscore), text:$score)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Section{
                    HStack{
                        Spacer()
                        if let message = errorMessage {
                            Text(message).foregroundColor(message == "保存成功" ? .green : .red)
                        }
                        Spacer()
                    }
                }.listRowBackground(Color.clear)  // 隐藏默认背景
                
            }
            .navigationTitle("\(subject.name)額外加分")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        guard let score = Double(score) else {
                            errorMessage = "請輸入有效的額外加分"
                            return
                        }
                        
                        guard subject.targetscore >= score else {
                            errorMessage = "額外加分大於目標分數"
                            return
                        }
                        subject.bonusscore = score
                        errorMessage = "保存成功"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            dismiss()
                        }
                    }){
                        Text("保存").foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
    }
}

