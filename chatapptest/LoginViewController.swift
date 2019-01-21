//
//  LoginViewController.swift
//  chatapptest
//
//  Created by Fredric Cliver on 21/01/2019.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUp: UIButton!
    let remoteconfig = RemoteConfig.remoteConfig()
    var color:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        color = remoteconfig["splash_background"].stringValue
        
        statusBar.backgroundColor = hexStringToUIColor(hex: color)
        loginButton.backgroundColor = hexStringToUIColor(hex: color)
        signUp.backgroundColor = hexStringToUIColor(hex: color)
        
        signUp.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func presentSignup(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(view, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
