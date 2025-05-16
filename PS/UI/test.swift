import SwiftUI

struct ProgressCardView: View {
    let progress: Double // 百分比進度，例如 0.75 表示 75%
    let subjectName: String


    var body: some View {
        ZStack {
            // 背景完整圓形
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 5)
                .opacity(0.2)
                .foregroundColor(.gray)
                .frame(width: 230, height: 120) // 確保包裹住卡片
            
            // 進度條
            RoundedRectangle(cornerRadius: 12)
                .trim(from: 0.0, to: progress) // 進度百分比
                .stroke(Color(red: 0.3, green: 0.8, blue: 0.8),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90)) // 將進度條起點設為頂部
                .frame(width: 120, height: 230) // 確保包裹住卡片
            
            // 包含內容的 Stack
            HStack {
                Text("ಠ_ಠ") // 左側的符號
                    .font(.largeTitle)
                    .padding()
                Text(subjectName) // 右側文字
                    .font(.headline)
                    .bold()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1) // 添加外邊框
            )
            
            .frame(width: 230, height: 120) // 確保包裹住卡片
        }
        .frame(width: 230, height: 120) // 整體大小

    }
}

struct ProgressCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCardView(progress: 0.2, subjectName: "math")
    }
}
