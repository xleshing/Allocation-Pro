import SwiftData

@Model
class User: Identifiable {
    @Attribute(.unique) var account: String // 帳號需唯一
    var password: String
    var subjects: [Subject] = []

    init(account: String, password: String) {
        self.account = account
        self.password = password
    }
    
}
