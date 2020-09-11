 import Foundation
 
 public struct NewRideWaypoints: Equatable, Codable {
    
    // MARK: - Properties
    let pickupLocation: Location
    let dropoffLocation: Location
    
    // MARK: - Methods
    public init(pickupLocation: Location, dropoffLocation: Location) {
        self.pickupLocation = pickupLocation
        self.dropoffLocation = dropoffLocation
    }
 }
 
 public struct NewRideRequest: Equatable, Codable {
    
    // MARK: - Properties
    public let waypoints: NewRideWaypoints
    public let rideOptionID: RideOptionID
    
    // MARK: - Methods
    public init(waypoints: NewRideWaypoints, rideOptionID: RideOptionID) {
        self.waypoints = waypoints
        self.rideOptionID = rideOptionID
    }
 }
