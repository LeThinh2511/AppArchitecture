import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class PickMeUpViewController: NiblessViewController {
    
    // MARK: - Properties
    // View Model
    let viewModel: PickMeUpViewModel
    
    // Child View Controllers
    let mapViewController: PickMeUpMapViewController
    let rideOptionPickerViewController: RideOptionPickerViewController
    let sendingRideRequestViewController: SendingRideRequestViewController
    
    // State
    let disposeBag = DisposeBag()
    
    // Factories
    let viewControllerFactory: PickMeUpViewControllerFactory
    
    // MARK: - Methods
    init(viewModel: PickMeUpViewModel,
         mapViewController: PickMeUpMapViewController,
         rideOptionPickerViewController: RideOptionPickerViewController,
         sendingRideRequestViewController: SendingRideRequestViewController,
         viewControllerFactory: PickMeUpViewControllerFactory) {
        self.viewModel = viewModel
        self.mapViewController = mapViewController
        self.rideOptionPickerViewController = rideOptionPickerViewController
        self.sendingRideRequestViewController = sendingRideRequestViewController
        self.viewControllerFactory = viewControllerFactory
        super.init()
    }
    
    public override func loadView() {
        view = PickMeUpRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        addFullScreen(childViewController: mapViewController)
        super.viewDidLoad()
        subscribe(to: viewModel.view)
        observeErrorMessages()
    }
    
    func subscribe(to observable: Observable<PickMeUpView>) {
        observable
            .subscribe(onNext: { [weak self] view in
                self?.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    func present(_ view: PickMeUpView) {
        switch view {
        case .initial:
            presentInitialState()
        case .selectDropoffLocation:
            presentDropoffLocationPicker()
        case .selectRideOption:
            dropoffLocationSelected()
        case .confirmRequest:
            presentConfirmControl()
        case .sendingRideRequest:
            presentSendingRideRequestScreen()
        case .final:
            dismissSendingRideRequestScreen()
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mapViewController.view.frame = view.bounds
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentInitialState() {
        if let _ = presentedViewController as? DropoffLocationPickerViewController {
            dismiss(animated: true)
        }
        remove(childViewController: rideOptionPickerViewController)
        confirmControl?.removeFromSuperview()
        confirmControl = nil
    }
    
    func presentWhereTo() {
        if let view = view as? PickMeUpRootView {
            view.presentWhereToControl()
        }
    }
    
    func presentDropoffLocationPicker() {
        let viewController = viewControllerFactory.makeDropoffLocationPickerViewController()
        present(viewController, animated: true)
    }
    
    func dropoffLocationSelected() {
        if presentedViewController is DropoffLocationPickerViewController {
            dismiss(animated: true)
        }
        presentRideOptionPicker()
    }
    
    func dismissWhereTo() {
        if let view = view as? PickMeUpRootView {
            view.dismissWhereToControl()
        }
    }
    
    func presentRideOptionPicker() {
        let child = rideOptionPickerViewController
        guard child.parent == nil else {
            return
        }
        
        addChild(child)
        child.view.frame = CGRect(x: 0,
                                  y: view.bounds.maxY - 140,
                                  width: view.bounds.width,
                                  height: 140)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    var confirmControl: UIButton?
    
    func presentConfirmControl() {
        if let _ = presentedViewController {
            dismiss(animated: true, completion: nil)
        }
        guard confirmControl.isEmpty else {
            return
        }
        
        let buttonBackground: UIView = {
            let background = UIView()
            background.backgroundColor = Color.background
            background.frame = CGRect(x: 0,
                                      y: rideOptionPickerViewController.view.frame.maxY,
                                      width: self.view.bounds.width,
                                      height: 70)
            return background
        }()
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = Color.lightButtonBackground
            button.setTitle("Confirm", for: .normal)
            button.frame = CGRect(x: 20,
                                  y: rideOptionPickerViewController.view.frame.maxY,
                                  width: self.view.bounds.width - 40,
                                  height: 50)
            button.addTarget(viewModel,
                             action: #selector(PickMeUpViewModel.sendRideRequest),
                             for: .touchUpInside)
            button.titleLabel?.font = .boldSystemFont(ofSize: 18)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 3
            return button
        }()
        
        view.addSubview(buttonBackground)
        view.addSubview(button)
        
        UIView.animate(withDuration: 0.7) {
            var rideOptionPickerFrame = self.rideOptionPickerViewController.view.frame
            rideOptionPickerFrame.origin.y -= 70
            self.rideOptionPickerViewController.view.frame = rideOptionPickerFrame
            
            var confirmControlFrame = button.frame
            confirmControlFrame.origin.y -= 70
            button.frame = confirmControlFrame
            
            var backgroundFrame = buttonBackground.frame
            backgroundFrame.origin.y -= 70
            buttonBackground.frame = backgroundFrame
        }
        
        self.confirmControl = button
    }
    
    func presentSendingRideRequestScreen() {
        present(sendingRideRequestViewController, animated: true)
    }
    
    func dismissSendingRideRequestScreen() {
        view.alpha = 0
        dismiss(animated: true) { [weak self] in
            self?.viewModel.finishedSendingNewRideRequest()
        }
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                self?.routePresentation(forErrorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    func routePresentation(forErrorMessage errorMessage: ErrorMessage) {
        if let presentedViewController = presentedViewController {
            presentedViewController.present(errorMessage: errorMessage,
                                            withPresentationState: viewModel.errorPresentation)
        } else {
            present(errorMessage: errorMessage,
                    withPresentationState: viewModel.errorPresentation)
        }
    }
}

extension Optional {
    
    var isEmpty: Bool {
        return self == nil
    }
    
    var exists: Bool {
        return self != nil
    }
}

protocol PickMeUpViewControllerFactory {
    
    func makeDropoffLocationPickerViewController() -> DropoffLocationPickerViewController
}
