//
//  StoryTableViewController.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-05.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class StoryTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
  
    
    var ref: DatabaseReference!
    @IBOutlet var storyTableView: UITableView!
    
    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut();
        self.dismiss(animated: true, completion: nil)
    }
    
    
    struct Story{
        var id = "";
        var title = "No title";
    }
    
    var userid = "user"; //To be used if auth is implemented
    
    var stories:[Story] = [];
    var storyTitles:[String] = [];
    var searchActive:Bool = false
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    var filteredStories:[String] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredStories = storyTitles.filter ({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            print("funkar?")
            return range.location != NSNotFound
            
        })
        
        if(filteredStories.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.storyTableView.reloadData()
    }
    
    let alert = UIAlertController(title: "Create new story", message: "Enter a title for the story", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTableView.delegate = self
        storyTableView.dataSource = self
        searchBar.delegate = self
        // Firebase dbs reference
        ref = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
            userid = user.uid;
            newStoryAlertPreperation();
            fetchStories();
        } else {
            // No user is signed in.
            // ...
        }
    }
    
    func newStoryAlertPreperation(){
        alert.addTextField { (textField) in
            textField.text = "Don Quixote";
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.ref.child("users").child(self.userid).child("stories").childByAutoId().setValue(["name": textField.text]);
            self.fetchStories();
        }));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ));
    }
    
    func fetchStories(){
        stories.removeAll(keepingCapacity: false);
        ref.child("users").child(userid).child("stories").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary;
                var story = Story();
                story.title = value?["name"] as? String ?? "";
                story.id = child.key;
                self.stories.append(story);
                self.storyTitles.append(story.title);
            }
            self.storyTableView.reloadData();
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredStories.count
        }
        
        return stories.count + 1
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ref.child("users").child(userid).child("stories").child(self.stories[indexPath.row].id).removeValue();
            self.fetchStories();
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(searchActive)
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell;
            //cell.titleLabel?.text = stories[indexPath.row].title;
            cell.titleLabel?.text = filteredStories[indexPath.row]
            return cell;
        }
        else if indexPath.row < stories.count{
            print("does this happen?")
            let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell;
            cell.titleLabel?.text = stories[indexPath.row].title;

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addStoryCell", for: indexPath) as! AddTableViewCell;
            return cell
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row < stories.count){
            return true;
        }else{
            return false;
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1;
    }

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

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < stories.count{
            performSegue(withIdentifier: "chapterTableSegue", sender: indexPath.row);
        }else{
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chapterTableSegue"{
            if let chapterTable = segue.destination as? ChapterTableViewController {
                if let i = sender as? Int { //row/cell i is tapped...
                    if searchActive{
                        chapterTable.currentStory = stories.filter{$0.title == filteredStories[i]}[0];
                    }else{
                        chapterTable.currentStory = stories[i];
                    }
                    
                }
            }
        }
    }
    

}
