import Foundation
import RxSwift

public class SignedInViewModel: DeterminedPickUpLocationResponder,
                                NewRideRequestAcceptedResponder,
                                GoToNewRideNavigator,
                                DoneWithProfileResponder {
    
    // MARK: - Properties
    public var view: Observable<SignedInView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<SignedInView>(value: .gettingUsersLocation)
    
    public var showingProfileScreen: Observable<Bool> { return showingProfileScreenSubject.asObservable() }
    private let showingProfileScreenSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Methods
    public init() {}
    
    public func pickUpUser(at location: Location) {
        viewSubject.onNext(.pickMeUp(pickupLocation: location))
    }
    
    public func newRideRequestAccepted() {
        viewSubject.onNext(.waitingForPickup)
    }
    
    public func navigateToNewRide() {
        viewSubject.onNext(.gettingUsersLocation)
    }
    
    @objc
    public func presentProfileScreen() {
        showingProfileScreenSubject.onNext(true)
    }
    
    public func finishedViewingProfile() {
        showingProfileScreenSubject.onNext(false)
    }
}
