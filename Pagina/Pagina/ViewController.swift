//
//  ViewController.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-05.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningTextLabel: UILabel!
    
    @IBAction func login(_ sender: Any) {

        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if user != nil{
                self.performSegue(withIdentifier: "StoryTableViewSegue",
                                  sender: Any?.self);
                self.warningTextLabel.isHidden = true;
            }
            if let err = error {
                self.warningTextLabel.isHidden = false
                self.warningTextLabel.text = err.localizedDescription
            }else{
                self.warningTextLabel.isHidden = false;
                self.warningTextLabel.text = "unknown errror";
            }
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set warning label stuff
        warningTextLabel.isHidden = true
        warningTextLabel.lineBreakMode = .byWordWrapping
        warningTextLabel.numberOfLines = 3

        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

