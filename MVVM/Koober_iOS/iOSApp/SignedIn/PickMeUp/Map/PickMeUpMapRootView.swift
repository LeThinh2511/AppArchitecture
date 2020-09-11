import UIKit
import KooberUIKit
import KooberKit
import MapKit
import RxSwift
import RxCocoa

class PickMeUpMapRootView: MKMapView {
    
    // MARK: - Properties
    let viewModel_real: PickMeUpMapViewModel
    let disposeBag = DisposeBag()
    let defaultMapSpan = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
    let mapDropoffLocationSpan = MKCoordinateSpan(latitudeDelta: 0.017, longitudeDelta: 0.017)
    var imageCache: ImageCache
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: PickMeUpMapViewModel, imageCache: ImageCache) {
        self.viewModel_real = viewModel
        self.imageCache = imageCache
        super.init(frame: frame)
        delegate = self
        bindViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported by PickMeUpMapRootView.")
    }
    
    func bindViewModel() {
        viewModel_real.pickupLocation
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected pickup location observable error.") })
            .map(MapAnnotationType.makePickupLocationAnnotation(for:))
            .drive(onNext: { [weak self] annotation in
                self?.pickupLocationAnnotation = annotation
            })
            .disposed(by: disposeBag)
        
        
        viewModel_real.dropoffLocation
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected dropoff location observable error.") })
            .map(MapAnnotationType.makeDropoffLocationAnnotation(for:))
            .drive(onNext: { [weak self] annotation in
                guard let annotation = annotation else { return }
                self?.dropoffLocationAnnotation = annotation
                self?.zoomOutToShowDropoffLocation(pickupCoordinate: annotation.coordinate)
            })
            .disposed(by: disposeBag)
        
    }
    
    var viewModel = MapViewModel() {
        didSet {
            let currentAnnotations = (annotations as! [MapAnnotation]) // In real world, cast instead of force unwrap.
            let updatedAnnotations = viewModel.availableRideLocationAnnotations
                + viewModel.pickupLocationAnnotations
                + viewModel.dropoffLocationAnnotations
            
            let diff = MapAnnotionDiff.diff(currentAnnotations: currentAnnotations, updatedAnnotations: updatedAnnotations)
            if !diff.annotationsToRemove.isEmpty {
                removeAnnotations(diff.annotationsToRemove)
            }
            if !diff.annotationsToAdd.isEmpty {
                addAnnotations(diff.annotationsToAdd)
            }
            
            if !viewModel.dropoffLocationAnnotations.isEmpty {
                zoomOutToShowDropoffLocation(pickupCoordinate: viewModel.pickupLocationAnnotations[0].coordinate)
            } else {
                zoomIn(pickupCoordinate: viewModel.pickupLocationAnnotations[0].coordinate)
            }
        }
    }
    
    var pickupLocationAnnotation: MapAnnotation? {
        didSet {
            guard oldValue != pickupLocationAnnotation else { return }
            removeAnnotation(oldValue)
            addAnnotation(pickupLocationAnnotation)
            guard let annotation = pickupLocationAnnotation else { return }
            zoomIn(pickupCoordinate: annotation.coordinate)
        }
    }
    
    var dropoffLocationAnnotation: MapAnnotation? {
        didSet {
            guard oldValue != dropoffLocationAnnotation else { return }
            removeAnnotation(oldValue)
            addAnnotation(dropoffLocationAnnotation)
        }
    }
    
    func removeAnnotation(_ annotation: MapAnnotation?) {
        guard let annotation = annotation else { return }
        removeAnnotation(annotation)
    }
    
    func addAnnotation(_ annotation: MapAnnotation?) {
        guard let annotation = annotation else { return }
        addAnnotation(annotation)
    }
    
    func zoomIn(pickupCoordinate: CLLocationCoordinate2D) {
        let center = pickupCoordinate
        let span = defaultMapSpan
        let region = MKCoordinateRegion(center: center, span: span)
        setRegion(region, animated: false)
    }
    
    func zoomOutToShowDropoffLocation(pickupCoordinate: CLLocationCoordinate2D) {
        let center = pickupCoordinate
        let span = mapDropoffLocationSpan
        let region = MKCoordinateRegion(center: center, span: span)
        setRegion(region, animated: true)
    }
    
}

extension PickMeUpMapRootView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }
        let reuseID = reuseIdentifier(forAnnotation: annotation)
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) else {
            return MapAnnotationView(annotation: annotation, reuseIdentifier: reuseID, imageCache: imageCache)
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
    func reuseIdentifier(forAnnotation annotation: MapAnnotation) -> String {
        return annotation.imageIdentifier
    }
}
