//
//  SignupViewController.swift
//  chatapptest
//
//  Created by Fredric Cliver on 21/01/2019.
//

import UIKit
import Firebase
import FirebaseStorage

class SignupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let remoteconfig = RemoteConfig.remoteConfig()
    var color:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        color = remoteconfig["splash_background"].stringValue
        statusBar.backgroundColor = hexStringToUIColor(hex: color!)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        signup.backgroundColor = hexStringToUIColor(hex: color!)
        cancel.backgroundColor = hexStringToUIColor(hex: color!)
        
        signup.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        
    }
    
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            let uid = user?.user.uid
            let image = self.imageView.image?.jpegData(compressionQuality: 0.8)
            
            let imageRef = Storage.storage().reference().child("userImages").child(uid!)
            
            imageRef.putData(image!, metadata: nil, completion: {(StorageMetadata, Error) in
                
                imageRef.downloadURL(completion: { (url, err) in
                    
                    Database.database().reference().child(uid!).setValue(["username":self.name.text!, "profileImageUrl":url?.absoluteString])
                    
                })
                
            })
            
            
            
            
            
//
//            Storage.storage().reference().child("userImages").child(uid!).putData(image!, metadata: nil, completion: { (data, error) in
//                let imageUrl = data?.downloadURL()?.absoluteString
//                Database.database().reference().child(uid!).setValue(["name":self.name.text!, "profileImageUrl":imageUrl])
//            })
            
        }
    }
    
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
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
