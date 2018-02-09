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

    var ref:DatabaseReference!;
    var currentStory:StoryTableViewController.Story = StoryTableViewController.Story();
    var userid:String = "user";
    
    @IBOutlet weak var chapterNavbarTitle: UINavigationItem!
    @IBOutlet var chapterTableView: UITableView!
    struct Chapter {
        var id:String = "";
        var title:String = "";
        var content:String = "";
        var storyid = "";
    }
    
    var chapters:[Chapter] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference();
        
        chapterNavbarTitle.title = currentStory.title;
        
        ref.child("users").child(userid).child("stories").child(currentStory.id).child("chapters").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(self.currentStory.id);
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary;
                var chapter = Chapter();
                chapter.title = value?["name"] as? String ?? "";
                print(chapter.title);
                chapter.id = child.key;
                chapter.content = value?["text"] as? String ?? "";
                chapter.storyid = self.currentStory.id;
                self.chapters.append(chapter);
                self.chapterTableView.reloadData();
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chapters.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as! ChapterTableViewCell;
        cell.ChapterTitleLabel?.text = chapters[indexPath.row].title;
        return cell;
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "StoryEditSegue", sender: indexPath.row)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
