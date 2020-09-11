import UIKit

public class DropoffLocationPickerViewController: UINavigationController {
    
    // MARK: - Methods
    public init(contentViewController: DropoffLocationPickerContentViewController) {
        super.init(rootViewController: contentViewController)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationBar.prefersLargeTitles = true
    }
    
    @available(*, unavailable, message: "Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    }
}
