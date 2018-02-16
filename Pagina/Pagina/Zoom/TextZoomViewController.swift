//
//  TextZoomViewController.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-15.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class TextZoomViewController: UIViewController {

    @IBOutlet weak var inspirationTextView: UITextView!
    
    var currentInspiration: StoryEditViewController.Inspiration = StoryEditViewController.Inspiration();
    var currentChapter: ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
   
    @IBAction func deleteTextButton(_ sender: Any) {
        let ref:DatabaseReference = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
    ref.child("users").child(user.uid).child("stories").child(self.currentChapter.storyid).child("chapters").child(self.currentChapter.id).child("inspirations").child(self.currentInspiration.id).removeValue();
        navigationController?.popViewController(animated: true);
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set text
        inspirationTextView.text = currentInspiration.text;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
