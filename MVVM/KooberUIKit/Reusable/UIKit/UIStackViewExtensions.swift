import UIKit

extension UIStackView {

  // MARK: - Methods
  public func removeAllArangedSubviews() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }
}
