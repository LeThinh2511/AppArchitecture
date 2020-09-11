import Foundation
import KooberKit

extension UIViewController {

  public func present(_ errorMessage: ErrorMessage) {
    let alert = UIAlertController(title: errorMessage.title,
                                  message: errorMessage.message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension ErrorMessage {

  public static func makeUnknown() -> ErrorMessage {
    return ErrorMessage(title: "Unknown Issue",
                        message: "Koober ran into an unexpected issue, please try again or contact us.")
  }
}
