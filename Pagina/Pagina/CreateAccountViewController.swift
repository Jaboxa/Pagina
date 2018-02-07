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
        print("Nudå")
        Auth.auth().createUser(withEmail: createEmailTextField.text!, password: createPasswordTextField.text!) { (user, error) in
            
            if let theUser = user {
                print(theUser.email!)
            }else if let err = error{
                self.warningTextLabel.isHidden = false;
                self.warningTextLabel.text = err.localizedDescription;
            }else{
                print("unknown errror");
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.warningTextLabel.isHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
