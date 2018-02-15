//
//  CreateAccountViewController.swift
//  Pagina
//
//  Created by user on 2/6/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var warningTextLabel: UILabel!
    @IBOutlet weak var createEmailLabel: UILabel!
    
    @IBOutlet weak var createEmailTextField: UITextField!
    
    @IBOutlet weak var createPasswordLabel: UILabel!
    
    @IBOutlet weak var createPasswordTextField: UITextField!
    
    @IBAction func createAccountButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: createEmailTextField.text!, password: createPasswordTextField.text!) { (user, error) in
            
            if user != nil {
                self.navigationController?.popViewController(animated: true)
                self.warningTextLabel.isHidden = true;
            }else if let err = error{
                self.warningTextLabel.isHidden = false;
                self.warningTextLabel.text = err.localizedDescription;
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //set warning label stuff
        self.warningTextLabel.isHidden = true;
        self.warningTextLabel.lineBreakMode = .byWordWrapping
        self.warningTextLabel.numberOfLines = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
