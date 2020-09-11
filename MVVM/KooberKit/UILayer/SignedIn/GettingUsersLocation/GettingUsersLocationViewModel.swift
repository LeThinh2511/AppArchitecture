import Foundation
import RxSwift

public class GettingUsersLocationViewModel {
    
    // MARK: - Properties
    let determinedPickupLocationResponder: DeterminedPickUpLocationResponder
    let locator: Locator
    
    // MARK: - Methods
    public init(determinedPickUpLocationResponder: DeterminedPickUpLocationResponder,
                locator: Locator) {
        self.determinedPickupLocationResponder = determinedPickUpLocationResponder
        self.locator = locator
    }
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    public func getUsersCurrentLocation() {
        locator
            .getUsersCurrentLocation()
            .done(determinedPickupLocationResponder.pickUpUser(at:))
            .catch { error in
                let errorMessage = ErrorMessage(title: "Error Getting Location",
                                                message: "Could not get your location. Please check location settings and try again.")
                self.errorMessagesSubject.onNext(errorMessage)
            }
    }
}
