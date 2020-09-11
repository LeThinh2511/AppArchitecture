import Foundation

public enum LoadedState<T: Equatable>: Equatable {
    
    case notLoaded
    case loaded(state: T)
}
