import Foundation
import PromiseKit

public protocol LocationRepository {
    
    func searchForLocations(using query: String, pickupLocation: Location) -> Promise<[NamedLocation]>
}
