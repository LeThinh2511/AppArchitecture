import UIKit
import KooberUIKit
import KooberKit

public class GettingUsersLocationRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: GettingUsersLocationViewModel
    
    let appLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "roo_logo"))
        imageView.backgroundColor = Color.background
        return imageView
    }()
    
    let gettingLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "Finding your location..."
        label.textColor = .white
        return label
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: GettingUsersLocationViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        viewModel.getUsersCurrentLocation()
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        backgroundColor = Color.background
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        addSubview(appLogoImageView)
        addSubview(gettingLocationLabel)
    }
    
    func activateConstraints() {
        activateConstraintsAppLogo()
        activateConstraintsLocationLabel()
    }
    
    func activateConstraintsAppLogo() {
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = appLogoImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let centerX = appLogoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([centerY, centerX])
    }
    
    func activateConstraintsLocationLabel() {
        gettingLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        let topY = gettingLocationLabel.topAnchor
            .constraint(equalTo: appLogoImageView.bottomAnchor, constant: 30)
        let centerX = gettingLocationLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([topY, centerX])
    }
}
