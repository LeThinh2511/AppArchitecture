import Foundation
import PromiseKit

public class RideOptionDataStoreInMemory: RideOptionDataStore {
    
    // MARK: - Properties
    var rideOptions: [LocationID: [RideOption]] = [:]
    let accessQueue = DispatchQueue(label: "com.razeware.kooberkit.rideoptiondatastore.inmemorystore.access")
    
    // MARK: - Methods
    public init() {
    }
    
    public func update(rideOptions: [RideOption], availableAt pickupLocationID: LocationID) -> Promise<[RideOption]> {
        return Promise { seal in
            self.accessQueue.async {
                self.rideOptions[pickupLocationID] = rideOptions
                seal.fulfill(rideOptions)
            }
        }
    }
    
    public func read(availableAt pickupLocationID: LocationID) -> Promise<[RideOption]> {
        return Promise { seal in
            self.accessQueue.async {
                let rideOptions = self.rideOptions[pickupLocationID] ?? []
                seal.fulfill(rideOptions)
            }
        }
    }
    
    public func flush() {
        self.accessQueue.async {
            self.rideOptions = [:]
        }
    }
}
