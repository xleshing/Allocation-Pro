import SwiftUI
import UniformTypeIdentifiers

//// 获取数据库路径的全局函数
//func getDatabaseURL() -> URL? {
//    let fileManager = FileManager.default
//    let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
//    return appSupportURL?.appendingPathComponent("container.sqlite")
//}

struct OptionUIView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Binding var showlogin: Bool

    var body: some View {
        NavigationStack {
            if !appState.isLoggedIn {
                List {
                    Section {
                        Button(action: {
                            if !appState.isLoggedIn {
                                dismiss()
                                showlogin = true
                            } else {
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
            } else {
                List {
                    NavigationLink(destination: TargetscoreCardView()) {
                        HStack {
                            Text("目標分數")
                                .font(.body)
                                .bold()
                        }
                    }
                    NavigationLink(destination: BonusscoreCardView()) {
                        HStack {
                            Text("額外加分")
                                .font(.body)
                                .bold()
                        }
                    }
                    NavigationLink(destination: EditPredictModeView()) {
                        HStack {
                            Text("預測模式")
                                .font(.body)
                                .bold()
                        }
                    }
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Text("關於")
                                .font(.body)
                                .bold()
                        }
                    }
//                    // 导出功能
//                    Button(action: {
//                        exportDatabase()
//                    }) {
//                        HStack {
//                            Text("導出資料庫")
//                                .font(.body)
//                                .bold()
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    // 导入功能
//                    Button(action: {
//                        showImportMenu = true
//                    }) {
//                        HStack {
//                            Text("導入資料庫")
//                                .font(.body)
//                                .bold()
//                                .foregroundColor(.blue)
//                        }
//                    }
                }
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.large)
//        .sheet(isPresented: $showImportMenu) {
//            ImportDatabaseView()
//        }
    }
//
//    // 导出数据库
//    func exportDatabase() {
//        guard let databaseURL = getDatabaseURL() else {
//            print("Database file not found.")
//            return
//        }
//        let activityVC = UIActivityViewController(activityItems: [databaseURL], applicationActivities: nil)
//        if let topVC = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first?.windows.first?.rootViewController {
//            topVC.present(activityVC, animated: true, completion: nil)
//        }
//    }
}
//
//struct ImportDatabaseView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(onFileSelected: importDatabase)
//    }
//
//    func importDatabase(from sourceURL: URL) {
//        let fileManager = FileManager.default
//        guard let databaseURL = getDatabaseURL() else {
//            print("Database path not found.")
//            return
//        }
//        do {
//            if fileManager.fileExists(atPath: databaseURL.path) {
//                try fileManager.removeItem(at: databaseURL)
//            }
//            try fileManager.copyItem(at: sourceURL, to: databaseURL)
//            print("Database imported successfully.")
//        } catch {
//            print("Error importing database: \(error)")
//        }
//    }
//
//    class Coordinator: NSObject, UIDocumentPickerDelegate {
//        private let onFileSelected: (URL) -> Void
//
//        init(onFileSelected: @escaping (URL) -> Void) {
//            self.onFileSelected = onFileSelected
//        }
//
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            guard let selectedURL = urls.first else { return }
//            onFileSelected(selectedURL)
//        }
//
//        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//            print("Document picker was cancelled.")
//        }
//    }
//}
