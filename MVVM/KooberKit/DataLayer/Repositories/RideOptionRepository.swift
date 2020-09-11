import Foundation
import PromiseKit

public protocol RideOptionRepository {
    
    func readRideOptions(availableAt pickupLocation: Location) -> Promise<[RideOption]>
}
