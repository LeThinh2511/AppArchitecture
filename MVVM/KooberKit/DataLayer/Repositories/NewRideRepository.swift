import Foundation
import PromiseKit

public protocol NewRideRepository {
    
    func request(newRide: NewRideRequest) -> Promise<Void>
}
