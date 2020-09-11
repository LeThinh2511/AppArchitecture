import UIKit
import KooberUIKit
import RxSwift
import KooberKit

class PickMeUpRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: PickMeUpViewModel
    let disposeBag = DisposeBag()
    let whereToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Where to?", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(Color.darkTextColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: PickMeUpViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        addSubview(whereToButton)
        bindWhereToButtonToViewModel()
    }
    
    func bindWhereToButtonToViewModel() {
        whereToButton.addTarget(viewModel,
                                action: #selector(PickMeUpViewModel.showSelectDropoffLocationView),
                                for: .touchUpInside)
        
        viewModel.shouldDisplayWhereTo
            .asDriver(onErrorJustReturn: true)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] shouldDisplayWhereTo in
                if shouldDisplayWhereTo {
                    self?.presentWhereToControl()
                } else {
                    self?.dismissWhereToControl()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let buttonMargin = CGFloat(50.0)
        let buttonWidth = width - buttonMargin * 2.0
        whereToButton.frame = CGRect(x: 50, y: 100, width: buttonWidth, height: 50)
        whereToButton.layer.shadowPath = UIBezierPath(rect: whereToButton.bounds).cgPath
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        bringSubviewToFront(whereToButton)
    }
}

extension PickMeUpRootView: PickMeUpUserInterface {
    
    func dismissWhereToControl() {
        whereToButton.removeFromSuperview()
    }
    func presentWhereToControl() {
        addSubview(whereToButton)
    }
}
