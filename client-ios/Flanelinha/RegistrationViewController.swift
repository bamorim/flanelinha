import UIKit
import Alamofire

class RegistrationViewController: UIViewController {

    @IBOutlet weak var identificationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var plateABCTextField: UITextField!
    @IBOutlet weak var plate1234TextField: UITextField!
    @IBOutlet weak var disabledSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: Any) {
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "document_number": identificationTextField.text!,
            "disabled": disabledSwitch.isOn,
            "plate_number": String(format: "%@%@", plateABCTextField, plate1234TextField)
        ]
        
        Alamofire.request("http://10.20.3.166:3000/account", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            let jsonResponse = response.result.value as! [String:AnyObject]
            let id = jsonResponse["id"] as! Int
            UserDefaults.standard.set(id, forKey: "userID")
            let rootVC = TabBarController.instance()
            UIApplication.shared.keyWindow?.rootViewController = rootVC
        })
    }
    
    
    

}
