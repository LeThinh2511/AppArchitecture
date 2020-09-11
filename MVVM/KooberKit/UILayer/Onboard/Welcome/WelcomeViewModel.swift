import Foundation

public class WelcomeViewModel {
    
    // MARK: - Properties
    let goToSignUpNavigator: GoToSignUpNavigator
    let goToSignInNavigator: GoToSignInNavigator
    
    // MARK: - Methods
    public init(goToSignUpNavigator: GoToSignUpNavigator,
                goToSignInNavigator: GoToSignInNavigator) {
        self.goToSignUpNavigator = goToSignUpNavigator
        self.goToSignInNavigator = goToSignInNavigator
    }
    
    @objc
    public func showSignUpView() {
        goToSignUpNavigator.navigateToSignUp()
    }
    
    @objc
    public func showSignInView() {
        goToSignInNavigator.navigateToSignIn()
    }
}
