import Foundation

public protocol SignedInResponder {
    
    func signedIn(to userSession: UserSession)
}
