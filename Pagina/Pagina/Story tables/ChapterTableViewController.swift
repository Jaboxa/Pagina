//
//  ChapterTableViewController.swift
//  Pagina
//
//  Created by user on 2/8/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class ChapterTableViewController: UITableViewController {
    
    @IBOutlet weak var chapterNavbarTitle: UINavigationItem!
    @IBOutlet var chapterTableView: UITableView!
    struct Chapter {
        var id:String = "";
        var title:String = "";
        var content:String = "";
        var storyid = "";
    }
    
    var chapters:[Chapter] = [];
    var ref:DatabaseReference!; // Firebase ref
    var currentStory:StoryTableViewController.Story = StoryTableViewController.Story(); //contains id:s for firebase etc
    var userid:String = "";
    
        let alert = UIAlertController(title: "Create new chapter", message: "Enter a title for the chapter", preferredStyle: .alert)
    
    
    // Class
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference();
        
        chapterNavbarTitle.title = currentStory.title; //Where are we? On Story...
        
        if let user = Auth.auth().currentUser {
            userid = user.uid;
            newChapterAlertPreperation();
            fetchChapters();
        } else {
            // No user is signed in.
            self.dismiss(animated: true, completion: nil);  // What are you doing here? Get out!
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Alert
    func newChapterAlertPreperation(){
        alert.addTextField { (textField) in
            textField.text = "";
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.ref.child("users").child(self.userid).child("stories").child(self.currentStory.id).child("chapters").childByAutoId().setValue(["name": textField.text]);
            self.fetchChapters();
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ));
    }
    
    
    // Fetch from firebase dbs
    func fetchChapters(){
        chapters.removeAll(keepingCapacity: false); ref.child("users").child(userid).child("stories").child(currentStory.id).child("chapters").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary;
                var chapter = Chapter();
                chapter.title = value?["name"] as? String ?? "";
                chapter.id = child.key;
                chapter.content = value?["text"] as? String ?? "";
                chapter.storyid = self.currentStory.id;
                self.chapters.append(chapter);
            }
            
            self.chapterTableView.reloadData();
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Table

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count + 1;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < chapters.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as! ChapterTableViewCell;
            cell.ChapterTitleLabel?.text = chapters[indexPath.row].title;
            return cell;
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addChapterCell", for: indexPath) as! AddTableViewCell;
            return cell;
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ref.child("users").child(userid).child("stories").child(self.currentStory.id).child("chapters").child(self.chapters[indexPath.row].id).removeValue(); //remove from dbs
            self.fetchChapters(); //reload
            
        }
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row < chapters.count){
            return true;
        }else{
            return false; //Add-button should not be removable :) 
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < chapters.count{
            performSegue(withIdentifier: "StoryEditSegue", sender: indexPath.row)
        }else{
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryEditSegue" {
            if let storyEdit = segue.destination as? StoryEditViewController {
                if let i = sender as? Int { //row/cell i is tapped...
                    storyEdit.currentChapter = chapters[i];
                }
            }
        }
    }
 

}
