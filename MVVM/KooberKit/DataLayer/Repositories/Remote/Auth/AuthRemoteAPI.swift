import Foundation
import PromiseKit

public protocol AuthRemoteAPI {
    
    func signIn(username: String, password: String) -> Promise<UserSession>
    func signUp(account: NewAccount) -> Promise<UserSession>
}
