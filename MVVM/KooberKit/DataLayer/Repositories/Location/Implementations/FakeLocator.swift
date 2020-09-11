import Foundation
import PromiseKit

public class FakeLocator: Locator {
    
    // MARK: - Methods
    public init() {}
    
    public func getUsersCurrentLocation() -> Promise<Location> {
        return Promise { seal in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
                let location = Location(id: "0", latitude: -33.864308, longitude: 151.209146)
                seal.fulfill(location)
            }
        }
    }
}
