import UIKit
import KooberUIKit
import KooberKit
import RxSwift
import RxCocoa

public class GettingUsersLocationViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: GettingUsersLocationViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(viewModelFactory: GettingUsersLocationViewModelFactory) {
        self.viewModel = viewModelFactory.makeGettingUsersLocationViewModel()
        super.init()
    }
    
    override public func loadView() {
        view = GettingUsersLocationRootView(viewModel: viewModel)
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
}

protocol GettingUsersLocationViewModelFactory {
    
    func makeGettingUsersLocationViewModel() -> GettingUsersLocationViewModel
}
