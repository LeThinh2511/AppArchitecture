import Foundation

public protocol UserSessionCoding {
    
    func encode(userSession: UserSession) -> Data
    func decode(data: Data) -> UserSession
}
