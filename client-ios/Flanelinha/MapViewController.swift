import UIKit
import MapKit
import Alamofire
import DLLocalNotifications

protocol HandleMapSearch: class {
    func showPlace(_ placemark: MKPlacemark)
}

typealias appType = (name: String, urlString: String, format: String)
var installedNavigationApps = [appType]()
let navigationApps: [appType] = [(name: "Apple Maps", urlString: "http://maps.apple.com", format: "http://maps.apple.com/maps?q=%@,%@"),
                                 (name: "Waze", urlString: "waze://", format: "waze://?ll=%@,%@&navigate=yes"),
                                 (name: "Google Maps", urlString: "comgooglemaps://", format: "comgooglemaps://?saddr=&daddr=%@,%@&directionsmode=driving")]

var name: String!
var latitude: String!
var longitude: String!

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
        
        let selectedLatitude = Float(String(selectedPlace.coordinate.latitude))!
        let selectedLongitude = Float(String(selectedPlace.coordinate.longitude))!
        
        let parameters: Parameters = [
            "account_id": UserDefaults.standard.integer(forKey: "userID"),
            "trip": [
                "destination_latitude": selectedLatitude,
                "destination_longitude": selectedLongitude
            ]
        ]
        
        Alamofire.request("http://10.20.3.166:3000/trips", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            let jsonResponse = response.result.value as! [String:AnyObject]
            
            let tripID = jsonResponse["id"] as! Int
            UserDefaults.standard.set(tripID, forKey: "tripID")
            
            let parking = jsonResponse["parking"] as! [String:AnyObject]
            name = parking["name"] as! String
            latitude = String(parking["latitude"] as! Double)
            longitude = String(parking["longitude"] as! Double)
            
            let alert = UIAlertController(title: "Encontramos uma vaga próxima", message: String(format: "Modificamos a direção para o estacionamento %@.", name), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.showNavigationOptions()
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func showNavigationOptions() {
        self.scheludeLocalNotificationOfSuccess()
        let alert = UIAlertController(title: nil, message: "Escolha o aplicativo", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let appButton = UIAlertAction(title: app.name, style: .default, handler: { _ in
                self.scheludeLocalNotificationOfSuccess()
                let urlString = String(format: app.format, latitude, longitude)
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            })
            alert.addAction(appButton)
        }
        let cancelButton = UIAlertAction(title: "Continuar aqui", style: .cancel, handler: { _ in
            
            let tripID = String(UserDefaults.standard.integer(forKey: "tripID"))
            let parameters: Parameters = [
                "account_id": UserDefaults.standard.integer(forKey: "userID")
            ]
            let url = String(format: "http://10.20.3.166:3000/trips/%@/reserve", tripID)
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let stopController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StopViewController") as! StopViewController
                    UIApplication.shared.keyWindow?.rootViewController = stopController
                }
            })
        })
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func scheludeLocalNotificationOfSuccess() {
        // The date you would like the notification to fire at
        let triggerDate = Date().addingTimeInterval(30)
        
        let firstNotification = DLNotification(identifier: "firstNotification", alertTitle: "Notification Alert", alertBody: "You have successfully created a notification", date: triggerDate, repeats: .None)
        
        let scheduler = DLNotificationScheduler()
        _ = scheduler.scheduleNotification(notification: firstNotification)
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
