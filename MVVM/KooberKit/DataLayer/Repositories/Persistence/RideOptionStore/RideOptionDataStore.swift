import Foundation
import PromiseKit

public protocol RideOptionDataStore {
    
    func update(rideOptions: [RideOption], availableAt pickupLocationID: LocationID) -> Promise<[RideOption]>
    func read(availableAt pickupLocationID: LocationID) -> Promise<[RideOption]>
    func flush()
}
