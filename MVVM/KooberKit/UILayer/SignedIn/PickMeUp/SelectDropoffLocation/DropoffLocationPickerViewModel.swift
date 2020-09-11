import Foundation
import RxSwift

public class DropoffLocationPickerViewModel {
    
    // MARK: - Properties
    let pickupLocation: Location
    let locationRepository: LocationRepository
    let dropoffLocationDeterminedResponder: DropoffLocationDeterminedResponder
    let cancelDropoffLocationSelectionResponder: CancelDropoffLocationSelectionResponder
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObservable()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    let disposeBag = DisposeBag()
    
    public let searchInput = BehaviorSubject<String>(value: "")
    public let searchResults = BehaviorSubject<[NamedLocation]>(value: [])
    var currentSearchID: UUID?
    
    // MARK: - Methods
    public init(pickupLocation: Location,
                locationRepository: LocationRepository,
                dropoffLocationDeterminedResponder: DropoffLocationDeterminedResponder,
                cancelDropoffLocationSelectionResponder: CancelDropoffLocationSelectionResponder) {
        self.pickupLocation = pickupLocation
        self.locationRepository = locationRepository
        self.dropoffLocationDeterminedResponder = dropoffLocationDeterminedResponder
        self.cancelDropoffLocationSelectionResponder = cancelDropoffLocationSelectionResponder
        searchInput
            .asObservable()
            .subscribe(onNext: searchForDropoffLocations(using:))
            .disposed(by: disposeBag)
    }
    
    func searchForDropoffLocations(using query: String) {
        let searchID = UUID()
        currentSearchID = searchID
        locationRepository
            .searchForLocations(using: query, pickupLocation: pickupLocation)
            .done { [weak self] searchResults in
                guard searchID == self?.currentSearchID else { return }
                self?.update(searchResults: searchResults)
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Location Error",
                                                message: "Sorry, we ran into an unexpected error while getting locations.\nPlease try again.")
                self.errorMessagesSubject.onNext(errorMessage)
            }
    }
    
    private func update(searchResults: [NamedLocation]) {
        self.searchResults.onNext(searchResults)
    }
    
    public func select(dropoffLocation: NamedLocation) {
        dropoffLocationDeterminedResponder.dropOffUser(at: dropoffLocation.location)
    }
    
    @objc
    public func cancelDropoffLocationSelection() {
        cancelDropoffLocationSelectionResponder.cancelDropoffLocationSelection()
    }
}
