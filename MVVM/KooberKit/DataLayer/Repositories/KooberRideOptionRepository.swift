import Foundation
import PromiseKit

public class KooberRideOptionRepository: RideOptionRepository {
    
    // MARK: - Properties
    let remoteAPI: NewRideRemoteAPI
    let datastore: RideOptionDataStore
    
    // MARK: - Methods
    public init(remoteAPI: NewRideRemoteAPI,
                datastore: RideOptionDataStore) {
        self.remoteAPI = remoteAPI
        self.datastore = datastore
    }
    
    public func readRideOptions(availableAt pickupLocation: Location) -> Promise<[RideOption]> {
        return datastore
            .read(availableAt: pickupLocation.id)
            .then { rideOptions in
                self.fetchFromNetworkIfNeeded(pickupLocation: pickupLocation,
                                              rideOptionsFromDatastore: rideOptions)
            }
    }
    
    private func fetchFromNetworkIfNeeded(pickupLocation: Location,
                                          rideOptionsFromDatastore: [RideOption]) -> Promise<[RideOption]> {
        if !rideOptionsFromDatastore.isEmpty {
            return .value(rideOptionsFromDatastore)
        }
        return remoteAPI
            .getRideOptions(pickupLocation: pickupLocation)
            .then { rideOptions in
                return self.datastore.update(rideOptions: rideOptions, availableAt: pickupLocation.id)
            }
        
    }
}
