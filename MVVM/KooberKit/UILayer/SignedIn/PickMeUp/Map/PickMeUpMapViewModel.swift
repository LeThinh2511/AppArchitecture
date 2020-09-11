import Foundation
import RxSwift

public class PickMeUpMapViewModel {
    
    // MARK: - Properties
    public let pickupLocation: BehaviorSubject<Location>
    public let dropoffLocation = BehaviorSubject<Location?>(value: nil)
    
    // MARK: - Methods
    public init(pickupLocation: Location) {
        self.pickupLocation = BehaviorSubject(value: pickupLocation)
    }
}
