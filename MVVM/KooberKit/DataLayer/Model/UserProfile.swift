import Foundation

public struct UserProfile: Equatable, Codable {
    
    // MARK: - Properties
    public let name: String
    public let email: String
    public let mobileNumber: String
    public let avatar: URL
    
    // MARK: - Methods
    public init(name: String, email: String, mobileNumber: String, avatar: URL) {
        self.name = name
        self.email = email
        self.mobileNumber = mobileNumber
        self.avatar = avatar
    }
}
