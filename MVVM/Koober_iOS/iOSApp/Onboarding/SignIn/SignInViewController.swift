
import UIKit
import KooberUIKit
import KooberKit
import PromiseKit
import RxSwift

public class SignInViewController : NiblessViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: SignInViewModel
    
    // MARK: - Methods
    init(viewModelFactory: SignInViewModelFactory) {
        self.viewModel = viewModelFactory.makeSignInViewModel()
        super.init()
    }
    
    public override func loadView() {
        self.view = SignInRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                self?.present(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as! SignInRootView).configureViewAfterLayout()
    }
}

protocol SignInViewModelFactory {
    
    func makeSignInViewModel() -> SignInViewModel
}

extension SignInViewController {
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as! SignInRootView).moveContentForDismissedKeyboard()
            } else {
                (view as! SignInRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
