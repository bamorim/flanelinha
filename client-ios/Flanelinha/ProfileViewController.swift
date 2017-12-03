import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userID")
        let loginViewController = LoginViewController.instance()
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
}
