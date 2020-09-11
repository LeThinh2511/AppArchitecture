import UIKit
import KooberUIKit
import KooberKit

public class WelcomeViewController: NiblessViewController {
    
    // MARK: - Properties
    let welcomeViewModelFactory: WelcomeViewModelFactory
    
    // MARK: - Methods
    init(welcomeViewModelFactory: WelcomeViewModelFactory) {
        self.welcomeViewModelFactory = welcomeViewModelFactory
        super.init()
    }
    
    public override func loadView() {
        let viewModel = welcomeViewModelFactory.makeWelcomeViewModel()
        view = WelcomeRootView(viewModel: viewModel)
    }
}

protocol WelcomeViewModelFactory {
    
    func makeWelcomeViewModel() -> WelcomeViewModel
}
