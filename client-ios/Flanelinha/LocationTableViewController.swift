import UIKit
import MapKit

class LocationTableViewController: UITableViewController {

    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems = [MKMapItem]()
    var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func parseAddress(place: MKPlacemark) -> String {
        let addressLine = String(format:"%@, %@",
                                // street name
                                place.thoroughfare ?? "",
                                // street number
                                place.subThoroughfare ?? "")
        return addressLine
    }
    
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationResultCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(place: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.showPlace(selectedPlace)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = mapView,
            let searchBarText = searchController.searchBar.text else {
                return
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let coodinate2d = CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        request.region = MKCoordinateRegion(center: coodinate2d, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
