import Foundation
import RxSwift

public class MainViewModel: SignedInResponder, NotSignedInResponder {
    
    // MARK: - Properties
    public var view: Observable<MainView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<MainView>(value: .launching)
    
    // MARK: - Methods
    public init() {}
    
    public func notSignedIn() {
        viewSubject.onNext(.onboarding)
    }
    
    public func signedIn(to userSession: UserSession) {
        viewSubject.onNext(.signedIn(userSession: userSession))
    }
}
