import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class RideOptionPickerViewController: NiblessViewController {
    
    // MARK: - Properties
    // Dependencies
    let imageCache: ImageCache
    
    // State
    let viewModel: RideOptionPickerViewModel
    let pickupLocation: Location
    var selectedRideOptionID: RideOptionID?
    let disposeBag = DisposeBag()
    
    // Root View
    var rideOptionSegmentedControl: RideOptionSegmentedControl {
        return view as! RideOptionSegmentedControl
    }
    
    // MARK: - Methods
    init(pickupLocation: Location,
         imageCache: ImageCache,
         viewModelFactory: RideOptionPickerViewModelFactory) {
        self.pickupLocation = pickupLocation
        self.imageCache = imageCache
        self.viewModel = viewModelFactory.makeRideOptionPickerViewModel()
        super.init()
    }
    
    public override func loadView() {
        view = RideOptionSegmentedControl(frame: .zero,
                                          imageCache: imageCache,
                                          mvvmViewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        rideOptionSegmentedControl.mvvmViewModel.loadRideOptions(availableAt: pickupLocation,
                                                                 screenScale: UIScreen.main.scale)
        observeErrorMessages()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                self?.present(errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    class SegmentedControlStateReducer {
        static func reduce(from rideOptions: RideOptionPickerRideOptions) -> RideOptionSegmentedControlViewModel {
            let segments = RideOptionSegmentsFactory(state: rideOptions).makeSegments(screenScale: UIScreen.main.scale)
            return RideOptionSegmentedControlViewModel(segments: segments)
        }
    }
}

protocol RideOptionPickerViewModelFactory {
    
    func makeRideOptionPickerViewModel() -> RideOptionPickerViewModel
}
