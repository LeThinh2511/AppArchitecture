import UIKit
import KooberUIKit

class SendingRideRquestRootView: NiblessView {
    
    // MARK: - Properties
    var hierarchyNotReady = true
    
    lazy var requestStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            requestImageView,
            requestLabel
        ])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    let requestLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "Requesting Ride..."
        label.textColor = Color.darkTextColor
        label.textAlignment = .center
        return label
    }()
    
    let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "requesting_indicator")
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: - Methods
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        addSubview(requestStack)
    }
    
    func activateConstraints() {
        activateConstraintsRequestStack()
    }
    
    func activateConstraintsRequestStack() {
        requestStack.translatesAutoresizingMaskIntoConstraints = false
        let centerY = requestStack.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let centerX = requestStack.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([centerY, centerX])
    }
}
