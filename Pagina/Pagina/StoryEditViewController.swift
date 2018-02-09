//
//  StoryEditViewController.swift
//  Pagina
//
//  Created by user on 2/8/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class StoryEditViewController: UIViewController {

    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var storyEditTextView: UITextView!
    
    var saveTextTimer: Timer!
    var ref:DatabaseReference!
    var userid = "user"
    var currentText = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            userid = user.uid;
        } else {
            // No user is signed in.
            // ...
        }
        ref = Database.database().reference();
        navbarTitle.title = currentChapter.title;
        storyEditTextView.text = currentChapter.content;
        currentText = storyEditTextView.text;
        saveTextTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(saveText), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(true)
        saveTextTimer.invalidate();
        print("one last time!");
        saveText();
        currentChapter.content = currentText;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func saveText(){
        print("saving....");
        if storyEditTextView.text != currentText{
        self.ref.child("users").child(userid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).updateChildValues(["text": self.storyEditTextView.text]);
            currentText = storyEditTextView.text;
            print("saved!");
        }
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
