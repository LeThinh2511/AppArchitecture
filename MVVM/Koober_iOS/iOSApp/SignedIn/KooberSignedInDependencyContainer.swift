import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class KooberSignedInDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let userSessionRepository: UserSessionRepository
    let mainViewModel: MainViewModel
    
    // Context
    let userSession: UserSession
    
    // Longed-lived dependencies
    let signedInViewModel: SignedInViewModel
    let imageCache: ImageCache
    let locator: Locator
    
    
    // MARK: - Methods
    public init(userSession: UserSession, appDependencyContainer: KooberAppDependencyContainer) {
        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel()
        }
        func makeImageCache() -> ImageCache {
            return InBundleImageCache()
        }
        func makeLocator() -> Locator {
            return FakeLocator()
        }
        
        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.mainViewModel = appDependencyContainer.sharedMainViewModel
        
        self.userSession = userSession
        
        self.signedInViewModel = makeSignedInViewModel()
        self.imageCache = makeImageCache()
        self.locator = makeLocator()
    }
    
    // Signed-in
    public func makeSignedInViewController() -> SignedInViewController {
        let profileViewController = makeProfileViewController()
        return SignedInViewController(viewModel: signedInViewModel,
                                      userSession: userSession,
                                      profileViewController: profileViewController,
                                      viewControllerFactory: self)
    }
    
    // Getting user's location
    public func makeGettingUsersLocationViewController() -> GettingUsersLocationViewController {
        return GettingUsersLocationViewController(viewModelFactory: self)
    }
    
    public func makeGettingUsersLocationViewModel() -> GettingUsersLocationViewModel {
        return GettingUsersLocationViewModel(determinedPickUpLocationResponder: signedInViewModel,
                                             locator: locator)
    }
    
    // Pick-me-up
    public func makePickMeUpViewController(pickupLocation: Location) -> PickMeUpViewController {
        let pickMeUpDependencyContainer = KooberPickMeUpDependencyContainer(signedInDependencyContainer: self,
                                                                            pickupLocation: pickupLocation)
        return pickMeUpDependencyContainer.makePickMeUpViewController()
    }
    
    // Waiting for Pickup
    public func makeWaitingForPickupViewController() -> WaitingForPickupViewController {
        return WaitingForPickupViewController(viewModelFactory: self)
    }
    
    public func makeWaitingForPickupViewModel() -> WaitingForPickupViewModel {
        return WaitingForPickupViewModel(goToNewRideNavigator: signedInViewModel)
    }
    
    // View profile
    public func makeProfileViewController() -> ProfileViewController {
        let contentViewController = makeProfileContentViewController()
        return ProfileViewController(contentViewController: contentViewController)
    }
    
    private func makeProfileContentViewController() -> ProfileContentViewController {
        let viewModel = makeProfileViewModel()
        return ProfileContentViewController(viewModel: viewModel)
    }
    
    public func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(userSession: userSession,
                                notSignedInResponder: mainViewModel,
                                doneWithProfileResponder: signedInViewModel,
                                userSessionRepository: userSessionRepository)
    }
}

extension KooberSignedInDependencyContainer: SignedInViewControllerFactory {}

extension KooberSignedInDependencyContainer: GettingUsersLocationViewModelFactory, WaitingForPickupViewModelFactory {}
