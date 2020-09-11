import Foundation

enum PickMeUpRequestProgress {
    
    case initial(pickupLocation: Location)
    case waypointsDetermined(waypoints: NewRideWaypoints)
    case rideRequestReady(rideRequest: NewRideRequest)
}
