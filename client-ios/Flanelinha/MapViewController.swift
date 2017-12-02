import UIKit
import MapKit

protocol HandleMapSearch: class {
    func showPlace(_ placemark: MKPlacemark)
}

typealias appType = (name: String, urlString: String, format: String)
var installedNavigationApps = [appType]()
let navigationApps: [appType] = [(name: "Apple Maps", urlString: "http://maps.apple.com", format: "http://maps.apple.com/maps?q=%@,%@"),
                                 (name: "Waze", urlString: "waze://", format: "waze://?ll=%@,%@&navigate=yes"),
                                 (name: "Google Maps", urlString: "comgooglemaps://", format: "comgooglemaps://?saddr=&daddr=%@,%@&directionsmode=driving")]

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController!
    var selectedPlace: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        setupUserTrackingButton()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationTableViewController") as! LocationTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Digite o seu destino"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func setupUserTrackingButton() {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -15),
                                     button.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -15)])
    }
    
    func userDistance(from point: MKPointAnnotation) -> String? {
        guard let userLocation = mapView.userLocation.location else {
            return nil
        }
        
        let pointLocation = CLLocation(
            latitude:  point.coordinate.latitude,
            longitude: point.coordinate.longitude
        )
        
        let km = 1000.0
        let metersDistance = userLocation.distance(from: pointLocation)
        let distance = (metersDistance < km) ? String(format: "%@ m", metersDistance) : String(format: "%.1f km", (metersDistance / km))
        return distance
    }
    
    @objc func getDirections() {
        guard let selectedPlace = selectedPlace else {
            return
        }
        
        // TODO: send info to backend
        
        let alert = UIAlertController(title: nil, message: "Escolha o aplicativo", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let appButton = UIAlertAction(title: app.name, style: .default, handler: { _ in
                let latitude = String(selectedPlace.coordinate.latitude)
                let longitude = String(selectedPlace.coordinate.longitude)
                let urlString = String(format: app.format, latitude, longitude)
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            })
            alert.addAction(appButton)
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            locationManager.requestAlwaysAuthorization()
        default:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error: \(error)")
    }
}

extension MapViewController: HandleMapSearch {
    func showPlace(_ placemark:MKPlacemark) {
        selectedPlace = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = userDistance(from: annotation)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = .red
        pinView?.canShowCallout = true
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        button.setImage(UIImage(named: "carIcon"), for: .normal)
        button.backgroundColor = UIColor(red: 4.0/255, green: 108.0/255, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}
