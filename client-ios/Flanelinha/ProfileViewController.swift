import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastDigitsLabel: UILabel!
    @IBOutlet weak var valideCardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = UserDefaults.standard.string(forKey: "userName")
        emailLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        lastDigitsLabel.text = UserDefaults.standard.string(forKey: "cardLastNumbers")
        valideCardLabel.text = UserDefaults.standard.string(forKey: "cardValidate")
    
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userID")
        let loginViewController = LoginViewController.instance()
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
}
