import Foundation

public enum SignedInView {
    
    case gettingUsersLocation
    case pickMeUp(pickupLocation: Location)
    case waitingForPickup
}
