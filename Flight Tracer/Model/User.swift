import FirebaseAuth

struct User {
    let id: String
    let email: String
}

extension User {
    init?(from result: AuthDataResult) {
        self.id = result.user.uid
        self.email = result.user.email != nil ? result.user.email! : "no email"
    }
}
