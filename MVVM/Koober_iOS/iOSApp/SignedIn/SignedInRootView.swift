import UIKit
import KooberUIKit
import KooberKit

class SignedInRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: SignedInViewModel
    
    let goToProfileControl: UIButton = {
        let button = UIButton(type: .system)
        let profileIcon = #imageLiteral(resourceName: "person_icon")
        button.setImage(profileIcon, for: .normal)
        button.tintColor = Color.darkTextColor
        return button
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: SignedInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        backgroundColor = Color.background
        
        addSubview(goToProfileControl)
        goToProfileControl.addTarget(viewModel, action: #selector(SignedInViewModel.presentProfileScreen), for: .touchUpInside)
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        bringSubviewToFront(goToProfileControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        goToProfileControl.frame = CGRect(x: frame.maxX - 85,
                                          y: 24,
                                          width: 100,
                                          height: 50)
    }
}
