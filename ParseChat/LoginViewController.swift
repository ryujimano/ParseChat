//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Ryuji Mano on 2/23/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        signUp()
    }
    @IBAction func onLogin(_ sender: Any) {
        login()
    }
    
    
    func signUp() {
        let user = PFUser()
        user.password = passwordField.text
        //user.email = emailField.text
        user.username = userNameField.text
        
        user.signUpInBackground { (succeeded, error) in
            if let error = error as? NSError {
                let errorString = error.userInfo["error"] as? NSString
                
                let alert = UIAlertController(title: "An Error Occurred", message: errorString as String?, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            } else {
                self.authSuccessful()
            }
        }
    }
    
    func login() {
        PFUser.logInWithUsername(inBackground: userNameField.text ?? "", password: passwordField.text ?? "") { (user, error: Error?) in
            if user != nil {
                self.authSuccessful()
            } else {
                let alert = UIAlertController(title: "An Error Occurred", message: (error?.localizedDescription)! as? String, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            }
        }
    }
    
    func authSuccessful() {
        performSegue(withIdentifier: "successSegue", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
