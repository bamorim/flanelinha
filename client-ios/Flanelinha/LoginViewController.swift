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
            NSLog("response: \(response)")
            let jsonResponse = response.result.value as! [String:AnyObject]
            let id = jsonResponse["id"] as! Int
            UserDefaults.standard.set(id, forKey: "userID")
            
            let name = jsonResponse["name"] as! String
            UserDefaults.standard.set(name, forKey: "userName")
            
            let email = jsonResponse["email"] as! String
            UserDefaults.standard.set(email, forKey: "userEmail")
            
            if let card = jsonResponse["card"] as? [String:AnyObject] {
                let cardLastNumbers = card["last_digits"] as! String
                let cardValidate = card["valid_thru"] as! String
                UserDefaults.standard.set(cardLastNumbers, forKey: "cardLastNumbers")
                UserDefaults.standard.set(cardValidate, forKey: "cardValidate")
                    
                let rootVC = TabBarController.instance()
                UIApplication.shared.keyWindow?.rootViewController = rootVC
            } else {
                //open viewController to save card
                let creditCardController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavControllerCreditCard") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = creditCardController
            }
            
        })
    }
    
}
