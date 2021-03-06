import UIKit
import KooberUIKit
import KooberKit
import PromiseKit
import RxSwift
import KooberKit

class RideOptionSegmentedControl: UIControl {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let mvvmViewModel: RideOptionPickerViewModel
    var viewModel = RideOptionSegmentedControlViewModel() {
        didSet {
            if oldValue != viewModel {
                loadAndRecreateButtons(withSegments: viewModel.segments)
            } else {
                update(withSegments: viewModel.segments)
            }
        }
    }
    
    private let maxRideOptionSegments = 3
    private let imageLoader: RideOptionSegmentButtonImageLoader
    private var buttons: [RideOptionID: RideOptionButton] = [:]
    private var rideOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         imageCache: ImageCache,
         mvvmViewModel: RideOptionPickerViewModel) {
        self.imageLoader = RideOptionSegmentButtonImageLoader(imageCache: imageCache)
        self.mvvmViewModel = mvvmViewModel
        super.init(frame: frame)
        
        constructViewHierarchy()
        wireMVVMViewModel()
    }
    
    func wireMVVMViewModel(){
        mvvmViewModel.pickerSegments
            .asDriver(onErrorRecover: { _ in fatalError("Unexpected error emitted from picker segments subject.") })
            .drive(onNext: { [weak self] _viewModel in
                self?.viewModel = _viewModel
            })
            .disposed(by: disposeBag)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("RideOptionSegmentedControl does not support instantiation via NSCoding.")
    }
    
    private func constructViewHierarchy() {
        
        func applyConstraints(toBackgroundBanner backgroundBanner: UIView) {
            backgroundBanner.translatesAutoresizingMaskIntoConstraints = false
            backgroundBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            backgroundBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            backgroundBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
            backgroundBanner.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        func applyConstraints(toRideOptionStackView rideOptionStackView: UIStackView) {
            rideOptionStackView.translatesAutoresizingMaskIntoConstraints = false
            rideOptionStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            rideOptionStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            rideOptionStackView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
            rideOptionStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        
        let backgroundBanner = UIView()
        backgroundBanner.backgroundColor = UIColor(red: 0,
                                                   green: 205/255.0,
                                                   blue: 188/255.0,
                                                   alpha: 1)
        
        addSubview(backgroundBanner)
        applyConstraints(toBackgroundBanner: backgroundBanner)
        
        addSubview(rideOptionStackView)
        applyConstraints(toRideOptionStackView: rideOptionStackView)
    }
    
    private func update(withSegments segments: [RideOptionSegmentViewModel]) {
        segments.forEach(update(withSegment:))
    }
    
    private func update(withSegment segment: RideOptionSegmentViewModel) {
        buttons[segment.id]?.isSelected = segment.isSelected
    }
    
    private func loadAndRecreateButtons(withSegments segments:  [RideOptionSegmentViewModel]) {
        loadButtonImages().done { loadedSegments in
            guard loadedSegments == self.viewModel.segments else {
                return
            }
            self.recreateButtons(withSegments: loadedSegments)
        }.catch { error in
            self.recreateButtons(withSegments: segments)
        }
    }
    
    private func loadButtonImages() -> Promise<[RideOptionSegmentViewModel]> {
        return imageLoader.loadImages(using: viewModel.segments)
    }
    
    private func recreateButtons(withSegments segments: [RideOptionSegmentViewModel]) {
        rideOptionStackView.removeAllArangedSubviews()
        segments.prefix(maxRideOptionSegments)
            .map(makeRideOptionButton(forSegment:))
            .map { id, button in
                store(button: button, forID: id)
            }
            .forEach(rideOptionStackView.addArrangedSubview)
    }
    
    private func makeRideOptionButton(forSegment segment: RideOptionSegmentViewModel) -> (RideOptionID, RideOptionButton) {
        let button = RideOptionButton(segment: segment)
        button.didSelectRideOption = { [weak self] id in
            self?.mvvmViewModel.select(rideOptionID: id)
        }
        return (segment.id, button)
    }
    
    private func store(button: RideOptionButton, forID id: RideOptionID) -> RideOptionButton {
        buttons[id] = button
        return button
    }
}
