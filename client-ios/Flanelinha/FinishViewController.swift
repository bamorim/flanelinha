import UIKit
import MapKit

class FinishViewController: UIViewController {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaults.standard.string(forKey: "parkedName")
        let lat = UserDefaults.standard.double(forKey: "parkedLatitude")
        let long = UserDefaults.standard.double(forKey: "parkedLongitude")
        
        mapView.showsUserLocation = true
        
        placeNameLabel.text = name
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = userDistance(from: annotation)
        mapView.addAnnotation(annotation)
        
        
        
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
    
    @IBAction func didTapFinish(_ sender: Any) {
        let rootVC = TabBarController.instance()
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }
    

}

extension FinishViewController: MKMapViewDelegate {
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
        return pinView
    }
}
