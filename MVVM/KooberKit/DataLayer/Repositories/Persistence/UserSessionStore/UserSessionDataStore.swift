import Foundation
import PromiseKit

public typealias AuthToken = String

public protocol UserSessionDataStore {
    
    func readUserSession() -> Promise<UserSession?>
    func save(userSession: UserSession) -> Promise<(UserSession)>
    func delete(userSession: UserSession) -> Promise<(UserSession)>
}
