import UIKit
import KooberUIKit
import KooberKit
import RxSwift

public class PickMeUpMapViewController: NiblessViewController {
    
    // MARK: - Properties
    // Factories
    let viewModelFactory: PickMeUpMapViewModelFactory
    
    // Dependencies
    let imageCache: ImageCache
    
    // State
    let disposeBag = DisposeBag()
    
    // Root View
    var mapView: PickMeUpMapRootView {
        return view as! PickMeUpMapRootView
    }
    
    // MARK: - Methods
    public init(viewModelFactory: PickMeUpMapViewModelFactory,
                imageCache: ImageCache) {
        self.viewModelFactory = viewModelFactory
        self.imageCache = imageCache
        super.init()
    }
    
    public override func loadView() {
        let viewModel = viewModelFactory.makePickMeUpMapViewModel()
        view = PickMeUpMapRootView(viewModel: viewModel,
                                   imageCache: imageCache)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.imageCache = imageCache
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

public protocol PickMeUpMapViewModelFactory {
    
    func makePickMeUpMapViewModel() -> PickMeUpMapViewModel
}
