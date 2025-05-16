//
//  EditPredictModeView.swift
//  PS
//
//  Created by 劉家弘 on 2025/1/9.
//
import SwiftUI
import SwiftData

struct EditPredictModeView: View {
    @EnvironmentObject var appState: AppState // 确保 AppState 已被正确注入

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    // Section with selectable options
                    Section (
                        footer:
                            VStack(alignment: .leading) {
                                Text("「平均模式」會把距離目標差多少分平均分攤到各科的各個項目（期中，期末．．．），所以所有項目的預測分數都會相同。")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("「權重模式」會把距離目標差多少分依照各細項佔比分攤到各科的各個項目（期中，期末．．．），所以佔比高的項目預測分數會比較高。")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                    ) {
                        // Average mode
                        HStack {
                            Text("平均模式")
                            Spacer()
                            if appState.predictmode == 0 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle()) // 扩大点击区域
                        .onTapGesture {
                            appState.predictmode = 0
                            appState.changepredictmode(mode: 0)
                        }
                        
                        // Weight mode
                        HStack {
                            Text("權重模式")
                            Spacer()
                            if appState.predictmode == 1 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle()) // 扩大点击区域
                        .onTapGesture {
                            appState.predictmode = 1
                            appState.changepredictmode(mode: 1)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("預測模式")
        .navigationBarTitleDisplayMode(.inline)
    }
}
