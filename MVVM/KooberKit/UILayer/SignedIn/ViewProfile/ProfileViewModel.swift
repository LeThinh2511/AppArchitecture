import Foundation
import RxSwift

public class ProfileViewModel {
    
    // MARK: - Properties
    public let userSession: UserSession
    public let userProfile: UserProfile
    let notSignedInResponder: NotSignedInResponder
    let doneWithProfileResponder: DoneWithProfileResponder
    let userSessionRepository: UserSessionRepository
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObservable()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    // MARK: - Methods
    public init(userSession: UserSession,
                notSignedInResponder: NotSignedInResponder,
                doneWithProfileResponder: DoneWithProfileResponder,
                userSessionRepository: UserSessionRepository) {
        self.userSession = userSession
        self.userProfile = userSession.profile
        self.notSignedInResponder = notSignedInResponder
        self.doneWithProfileResponder = doneWithProfileResponder
        self.userSessionRepository = userSessionRepository
    }
    
    @objc
    public func dismiss() {
        doneWithProfileResponder.finishedViewingProfile()
    }
    
    @objc
    public func signOut() {
        userSessionRepository.signOut(userSession: userSession)
            .done { _ in
                self.notSignedInResponder.notSignedIn()
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Sign Out Error",
                                                message: "We ran into an unexpteded error and we couldn't sign you out.\nPlease try again.")
                self.errorMessagesSubject.onNext(errorMessage)
            }
    }
}
