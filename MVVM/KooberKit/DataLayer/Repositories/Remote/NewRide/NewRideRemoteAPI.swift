import Foundation
import PromiseKit

public protocol NewRideRemoteAPI {
    
    func getRideOptions(pickupLocation: Location) -> Promise<[RideOption]>
    func getLocationSearchResults(query: String, pickupLocation: Location) -> Promise<[NamedLocation]>
    func post(newRideRequest: NewRideRequest) -> Promise<Void>
}

enum RemoteAPIError: Error {
    
    case unknown
    case createURL
    case httpError
}
