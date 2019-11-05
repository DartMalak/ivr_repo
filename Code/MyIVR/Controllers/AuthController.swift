//
//  AuthController.swift
//  MyIVR
//
//  Created by Андрей Хромов on 20/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin

class AuthController: UIViewController, LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print(1)
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("log out")
    }
    
    var signup: Bool = true {
        willSet {
            if newValue {
                print(1)
            }
            else {
                print(0)
            }
            
        }
    }
    
    @IBOutlet weak var segementedControl: UISegmentedControl!
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background1.png")!)
        


        emailField.delegate = self
        nameField.delegate = self
        passwordField.delegate = self

        emailField.placeholder = "Email"
        nameField.placeholder = "Name"
        passwordField.placeholder = "Password"
        // Do any additional setup after loading the view.
        showRegistration()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToNavController" {
            if let vc = segue.destination as? WelcomeScreen {
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    @IBAction func segmentChanged(_ sender: Any) {
        if segementedControl.selectedSegmentIndex == 0 {
            showRegistration()
        } else {
            showSignIn()
        }
    }
    
    func showRegistration() {
        nameField.alpha = 1
        nameField.isEnabled = true
        DoneBtn.titleLabel?.text = "Регистрация"
    }
    
    func showSignIn() {
        nameField.alpha = 0
        nameField.isEnabled = true
        DoneBtn.titleLabel?.text = "Вход"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func donePressed(_ sender: Any) {
        // вызов регистрации/входа
        if segementedControl.selectedSegmentIndex == 0 {
            register()
        } else {
            signIn()
        }
    }
    
    func register() {
        let email = emailField.text!
        let password = passwordField.text!
        let name = nameField.text!
        
        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error == nil {
                    if let result = result {
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name": name, "email": email, "password": password, "board": "1", "figure": "1"])
                        self.performSegue(withIdentifier: "GoToNavController", sender: nil)
                    }
                }
            }
        }
        else {
            showAlert(message: "Заполните все поля")
        }
    }
    
    func signIn() {
        let email = emailField.text!
        let password = passwordField.text!
        print("entered sign in")
        
        if !email.isEmpty && !password.isEmpty {
            print("data ok!")
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error == nil {
                    print("should perform segue")
                    self.performSegue(withIdentifier: "GoToNavController", sender: nil)
                } else {
                    print("блять")
                    print(error?.localizedDescription)
                }
            }
        }
        else {
            showAlert(message: "Заполните все поля")
        }
        
    }
}
extension AuthController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailField.text!
        let password = passwordField.text!
        let name = nameField.text!
        if signup {
            if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        if let result = result {
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name, "email": email, "password": password])
                            self.dismiss(animated: true, completion: nil)

                        }
                    }
                }
            }
            else {
                showAlert(message: "Заполните все поля")
            }
        }
        else {
            if !email.isEmpty && !password.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }

                }
            }
            else {
                showAlert(message: "Заполните все поля")
            }
        }
    return true
    }
}
