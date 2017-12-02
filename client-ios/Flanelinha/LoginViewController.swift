import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    class func instance() -> LoginViewController {
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalTransitionStyle = .flipHorizontal
        return loginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let parameters: Parameters = [
            "email": emailTextField.text!
        ]
        
        Alamofire.request("http://10.20.3.166:3000/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            let jsonResponse = response.result.value as! [String:AnyObject]
            let id = jsonResponse["id"] as! Int
            UserDefaults.standard.set(id, forKey: "userID")
            let rootVC = TabBarController.instance()
            UIApplication.shared.keyWindow?.rootViewController = rootVC
            })
    }
    
}
