import Foundation

public struct NamedLocation: Equatable, Codable {
    
    // MARK: - Properties
    public internal(set) var name: String
    public internal(set) var location: Location
    
    // MARK: - Methods
    public init(name: String, location: Location) {
        self.name = name
        self.location = location
    }
}
