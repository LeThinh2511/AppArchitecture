import UIKit
import KooberUIKit
import KooberKit

class WaitingForPickupRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: WaitingForPickupViewModel
    
    let successImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "success_message"))
        return imageView
    }()
    
    let newRideButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setTitle("Start New Ride", for: .normal)
        button.backgroundColor = Color.lightButtonBackground
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: WaitingForPickupViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        backgroundColor = Color.background
        addSubview(successImageView)
        addSubview(newRideButton)
        activateConstraintsSuccessImage()
        activateConstraintsNewRideButton()
        wireController()
    }
    
    func wireController() {
        newRideButton.addTarget(viewModel,
                                action: #selector(WaitingForPickupViewModel.startNewRide),
                                for: .touchUpInside)
    }
    
    func activateConstraintsSuccessImage() {
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = successImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let centerY = successImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
    
    func activateConstraintsNewRideButton() {
        newRideButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = newRideButton.leadingAnchor
            .constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        let trailing = newRideButton.trailingAnchor
            .constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        let bottom = safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: newRideButton.bottomAnchor,
                                                                 constant: 20)
        let height = newRideButton.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }
}
