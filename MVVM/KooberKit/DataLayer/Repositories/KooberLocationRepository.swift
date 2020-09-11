import Foundation
import PromiseKit

public class KooberLocationRepository: LocationRepository {
    
    // MARK: - Properties
    let remoteAPI: NewRideRemoteAPI
    
    // MARK: - Methods
    public init(remoteAPI: NewRideRemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    public func searchForLocations(using query: String, pickupLocation: Location) -> Promise<[NamedLocation]> {
        // This is short because there's no caching built into the repository.
        // If caching is desired this method would first check the cache and return values if search query results have been cached, otherwise search using the network.
        return remoteAPI.getLocationSearchResults(query: query, pickupLocation: pickupLocation)
    }
}
