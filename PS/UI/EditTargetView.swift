//
//  EditTargetView.swift
//  PS
//
//  Created by 劉家弘 on 2024/11/29.
//
import SwiftUI
import SwiftData

struct EditTargetView: View {
    let subject: Subject
    @Environment(\.dismiss) private var dismiss // 用於關閉視窗
    @State private var errorMessage: String?
    @State private var score: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    HStack{
                        //Text("\(subject.name)目標分數")
                        TextField(String(subject.targetscore), text:$score)
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
            .navigationTitle("\(subject.name)目標分數")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        guard let score = Double(score) else {
                            errorMessage = "請輸入有效的目標分數"
                            return
                        }
                        guard subject.bonusscore <= score else {
                            errorMessage = "目標分數小於額外加分"
                            return
                        }
                        subject.targetscore = score
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



