import Foundation

public class WaitingForPickupViewModel {
    
    // MARK: - Properties
    let goToNewRideNavigator: GoToNewRideNavigator
    
    // MARK: - Methods
    public init(goToNewRideNavigator: GoToNewRideNavigator) {
        self.goToNewRideNavigator = goToNewRideNavigator
    }
    
    @objc
    public func startNewRide() {
        goToNewRideNavigator.navigateToNewRide()
    }
}
