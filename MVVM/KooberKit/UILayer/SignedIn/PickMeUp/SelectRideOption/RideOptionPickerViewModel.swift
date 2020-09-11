import Foundation
import RxSwift
import PromiseKit

public class RideOptionPickerViewModel {
    
    // MARK: - Properties
    let repository: RideOptionRepository
    public var pickerSegments: Observable<RideOptionSegmentedControlViewModel> { return pickerSegmentsSubject.asObservable() }
    private let pickerSegmentsSubject = BehaviorSubject<RideOptionSegmentedControlViewModel>(value: RideOptionSegmentedControlViewModel())
    let rideOptionDeterminedResponder: RideOptionDeterminedResponder
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObservable()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    // MARK: - Methods
    public init(repository: RideOptionRepository,
                rideOptionDeterminedResponder: RideOptionDeterminedResponder) {
        self.repository = repository
        self.rideOptionDeterminedResponder = rideOptionDeterminedResponder
    }
    
    public func loadRideOptions(availableAt pickupLocation: Location, screenScale: CGFloat) {
        repository
            .readRideOptions(availableAt: pickupLocation)
            .then { (rideOptions: [RideOption]) -> Promise<RideOptionPickerRideOptions> in
                let pickerRideOptions = RideOptionPickerRideOptions(rideOptions: rideOptions)
                return Promise.value(pickerRideOptions)
            }
            .then { (pickerRideOptions: RideOptionPickerRideOptions) -> Promise<[RideOptionSegmentViewModel]>  in
                let factory = RideOptionSegmentsFactory(state: pickerRideOptions)
                let segments = factory.makeSegments(screenScale: screenScale)
                return Promise.value(segments)
            }
            .done { segments in
                self.pickerSegmentsSubject.onNext(RideOptionSegmentedControlViewModel(segments: segments))
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Ride Option Error",
                                                message: "We're having trouble getting available ride options. Please start a new ride and try again.")
                self.errorMessagesSubject.onNext(errorMessage)
            }
    }
    
    public func select(rideOptionID: RideOptionID) {
        do {
            var segments = try pickerSegmentsSubject.value().segments
            for (index, segment) in segments.enumerated() {
                segments[index].isSelected = (segment.id == rideOptionID)
            }
            pickerSegmentsSubject.onNext(RideOptionSegmentedControlViewModel(segments: segments))
            rideOptionDeterminedResponder.pickUpUser(in: rideOptionID)
        } catch {
            fatalError("Error reading value from picker segments subject.")
        }
    }
}
