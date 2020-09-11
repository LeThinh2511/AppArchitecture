import Foundation
import UIKit
import KooberKit
import RxSwift

extension UIViewController {

  // MARK: - Methods
  public func present(errorMessage: ErrorMessage) {
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
  }

  public func present(errorMessage: ErrorMessage,
                      withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>) {
    errorPresentation.onNext(.presenting)
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      errorPresentation.onNext(.dismissed)
      errorPresentation.onNext(nil)
    }
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
    
  }
}
