import UIKit

class TabBarController: UITabBarController {

    var mapViewController: MapViewController!
    var mapNavigationController: UINavigationController!
    
    class func instance() -> TabBarController {
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabViewController") as! TabBarController
        return tabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if viewController is UINavigationController,
            let navigationController = viewController as? UINavigationController,
            let viewController = navigationController.topViewController {
                
                if viewController is MapViewController {
                    self.mapNavigationController = navigationController
                    self.mapViewController = viewController as! MapViewController
                }
                
            }
        }
    }
    
}

