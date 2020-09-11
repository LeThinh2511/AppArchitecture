import Foundation
import KooberUIKit
import KooberKit

class LaunchRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: LaunchViewModel
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        styleView()
        loadUserSession()
    }
    
    private func styleView() {
        backgroundColor = Color.background
    }
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}
