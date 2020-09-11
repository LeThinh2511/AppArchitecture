import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class DropoffLocationPickerContentViewController: NiblessViewController {
    
    // MARK: - Properties
    // State
    let pickupLocation: Location
    let disposeBag = DisposeBag()
    
    // View Model
    let viewModel: DropoffLocationPickerViewModel
    
    // Root View
    var rootView: DropoffLocationPickerContentRootView {
        return view as! DropoffLocationPickerContentRootView
    }
    
    // MARK: - Methods
    init(pickupLocation: Location,
         viewModel: DropoffLocationPickerViewModel) {
        self.pickupLocation = pickupLocation
        self.viewModel = viewModel
        super.init()
        self.navigationItem.title = "Where To?"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .cancel,
                            target: viewModel,
                            action: #selector(DropoffLocationPickerViewModel.cancelDropoffLocationSelection))
    }
    
    public override func loadView() {
        view = DropoffLocationPickerContentRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController(with: viewModel)
        observeErrorMessages()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.searchController?.isActive = false
    }
    
    func setUpSearchController(with viewModel: DropoffLocationPickerViewModel) {
        let searchController = ObservableUISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.observable
            .asDriver(onErrorJustReturn: "")
            .debounce(0.9)
            .drive(viewModel.searchInput)
            .disposed(by: disposeBag)
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
            presentedViewController.present(errorMessage: errorMessage)
        } else {
            present(errorMessage: errorMessage)
        }
    }
}

protocol DropoffLocationViewModelFactory {
    
    func makeDropoffLocationPickerViewModel() -> DropoffLocationPickerViewModel
}
