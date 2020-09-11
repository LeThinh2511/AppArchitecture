import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class SignedInViewController: NiblessViewController {
    
    // MARK: - Properties
    // View Model
    let viewModel: SignedInViewModel
    
    // Child View Controllers
    let profileViewController: ProfileViewController
    var currentChildViewController: UIViewController?
    
    // State
    let userSession: UserSession
    let disposeBag = DisposeBag()
    
    // Factories
    let viewControllerFactory: SignedInViewControllerFactory
    
    // MARK: - Methods
    init(viewModel: SignedInViewModel,
         userSession: UserSession,
         profileViewController: ProfileViewController,
         viewControllerFactory: SignedInViewControllerFactory) {
        self.viewModel = viewModel
        self.userSession = userSession
        self.profileViewController = profileViewController
        self.viewControllerFactory = viewControllerFactory
        super.init()
    }
    
    public override func loadView() {
        view = SignedInRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe(to: viewModel.view)
        bindToShowingProfileState()
    }
    
    func bindToShowingProfileState() {
        viewModel
            .showingProfileScreen
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] showingProfileScreen in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.update(showingProfileScreen: showingProfileScreen)
            })
            .disposed(by: disposeBag)
    }
    
    func update(showingProfileScreen: Bool) {
        if showingProfileScreen {
            if presentedViewController.isEmpty {
                present(profileViewController, animated: true)
            }
        } else {
            if profileViewController.view.window != nil {
                dismiss(animated: true)
            }
        }
    }
    
    func subscribe(to observable: Observable<SignedInView>) {
        observable
            .subscribe(onNext: { [weak self] view in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    func present(_ view: SignedInView) {
        switch view {
        case .gettingUsersLocation:
            let viewController = viewControllerFactory.makeGettingUsersLocationViewController()
            transition(to: viewController)
        case .pickMeUp(let pickupLocation):
            let viewController = viewControllerFactory.makePickMeUpViewController(pickupLocation: pickupLocation)
            transition(to: viewController)
        case .waitingForPickup:
            let viewController = viewControllerFactory.makeWaitingForPickupViewController()
            transition(to: viewController)
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentChildViewController?.view.frame = view.bounds
    }
    
    func transition(to viewController: UIViewController) {
        remove(childViewController: currentChildViewController)
        addFullScreen(childViewController: viewController)
        currentChildViewController = viewController
    }
}

protocol SignedInViewControllerFactory {
    
    func makeGettingUsersLocationViewController() -> GettingUsersLocationViewController
    func makePickMeUpViewController(pickupLocation: Location) -> PickMeUpViewController
    func makeWaitingForPickupViewController() -> WaitingForPickupViewController
}
