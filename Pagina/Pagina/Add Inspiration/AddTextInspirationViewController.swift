//
//  AddTextInspirationViewController.swift
//  Pagina
//
//  Created by user on 2/12/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class AddTextInspirationViewController: UIViewController {

    @IBOutlet weak var inspirationTextView: UITextView!
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveInpirationText(_ sender: Any) {
        if let user = Auth.auth().currentUser{
            let ref = Database.database().reference();
            ref.child("users").child(user.uid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).child("inspirations").childByAutoId().updateChildValues(["type" : "text", "text" : inspirationTextView.text]);
            navigationController?.popViewController(animated: true)
        }
    }
    
}
