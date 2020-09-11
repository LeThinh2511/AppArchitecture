import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
    
    case present(view: ViewModelType)
    case presented(view: ViewModelType)
}
