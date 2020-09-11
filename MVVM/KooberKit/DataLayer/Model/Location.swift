import Foundation

public typealias LocationID = String

public struct Location: Identifiable, Equatable, Codable {
    
    // MARK: - Properties
    public internal(set) var id: LocationID
    public internal(set) var latitude: Double
    public internal(set) var longitude: Double
    
    // MARK: - Methods
    public init(id: LocationID, latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
}
