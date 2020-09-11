import Foundation
import PromiseKit

public protocol Locator {
    
    func getUsersCurrentLocation() -> Promise<Location>
}
