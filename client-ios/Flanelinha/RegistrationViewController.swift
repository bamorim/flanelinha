import UIKit
import Alamofire

class RegistrationViewController: UIViewController {

    @IBOutlet weak var identificationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var plateABCTextField: UITextField!
    @IBOutlet weak var plate1234TextField: UITextField!
    @IBOutlet weak var disabledSwitch: UISwitch!
    @IBOutlet weak var olderSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disabledSwitch.isOn = false
        olderSwitch.isOn = false
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: Any) {
        let parameters: Parameters = [
            "account": [
                "name": nameTextField.text!,
                "email": emailTextField.text!,
                "document_number": identificationTextField.text!,
                "disabled": disabledSwitch.isOn
            ],
            "car": [
                "nickname": "Meu Carro",
                "plate_number": String(format: "%@-%@", plateABCTextField.text!, plate1234TextField.text!)
            ]
        ]
        
        Alamofire.request("http://10.20.3.166:3000/accounts", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            NSLog("response: \(response)")
            let jsonResponse = response.result.value as! [String:AnyObject]
            let id = jsonResponse["id"] as! Int
            UserDefaults.standard.set(id, forKey: "userID")
            self.dismiss(animated: true, completion: nil)
        })
    }

}
