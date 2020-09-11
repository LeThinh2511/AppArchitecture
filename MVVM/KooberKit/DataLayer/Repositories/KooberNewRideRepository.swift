import Foundation
import PromiseKit

public class KooberNewRideRepository: NewRideRepository {
    
    // MARK: - Properties
    let remoteAPI: NewRideRemoteAPI
    
    // MARK: - Methods
    public init(remoteAPI: NewRideRemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    public func request(newRide: NewRideRequest) -> Promise<Void> {
        return remoteAPI.post(newRideRequest: newRide)
    }
}
