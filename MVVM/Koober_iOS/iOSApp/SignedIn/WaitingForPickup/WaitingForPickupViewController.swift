import UIKit
import KooberUIKit
import KooberKit

public class WaitingForPickupViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModelFactory: WaitingForPickupViewModelFactory
    
    // MARK: - Methods
    init(viewModelFactory: WaitingForPickupViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        super.init()
    }
    
    override public func loadView() {
        let viewModel = self.viewModelFactory.makeWaitingForPickupViewModel()
        view = WaitingForPickupRootView(viewModel: viewModel)
    }
}

public protocol WaitingForPickupViewModelFactory {
    
    func makeWaitingForPickupViewModel() -> WaitingForPickupViewModel
}
