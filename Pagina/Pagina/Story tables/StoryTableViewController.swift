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
    @IBOutlet var storyTableView: UITableView!
    
    
    struct Story{
        var id = "";
        var title = "No title";
    }
    
    var userid = "";
    let alert = UIAlertController(title: "Create new story", message: "Enter a title for the story", preferredStyle: .alert)
    
    var ref: DatabaseReference! //Firabase ref
    
    var stories:[Story] = [];
    var storyTitles:[String] = []; // For filtering searches
    var filteredStories:[String] = [] // To store the filtered searches
    var searchActive:Bool = false
    
    //Logout
    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut(); //ugly unwrapping, following firebase documentation
        self.dismiss(animated: true, completion: nil)
    }
    
    //Searchbar
    
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredStories = storyTitles.filter ({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
            
        })
        
        if(filteredStories.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.storyTableView.reloadData()
    }
    

    // Class
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase dbs reference
        ref = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
            userid = user.uid;
            newStoryAlertPreperation();
            fetchStories();
        } else {
            // No user is signed in.
            self.dismiss(animated: true, completion: nil);  // What are you doing here? Get out!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Alert
    func newStoryAlertPreperation(){
        alert.addTextField { (textField) in
            textField.text = "Don Quixote";
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.ref.child("users").child(self.userid).child("stories").childByAutoId().setValue(["name": textField.text]); //Save new story to dbs
            self.fetchStories(); //reload and get stories
        }));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ));
    }
    
    // fetch from dbs
    func fetchStories(){
        stories.removeAll(keepingCapacity: false); //Empty array
        
        //fetch!
        ref.child("users").child(userid).child("stories").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary;
                var story = Story();
                story.title = value?["name"] as? String ?? "";
                story.id = child.key; //This is awfully useful for deleting items
                self.stories.append(story);
                self.storyTitles.append(story.title);
            }
            self.storyTableView.reloadData(); //reload table
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //If searching, only show searches
        if(searchActive) {
            return filteredStories.count
        }
        
        //If not, show all stories + cell for adding new story
        return stories.count + 1
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ref.child("users").child(userid).child("stories").child(self.stories[indexPath.row].id).removeValue(); //Remove from dbs
            self.fetchStories(); //Reload
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row < stories.count){
            return true;
        }else{
            return false; // add-button should not be removable
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell;
            cell.titleLabel?.text = filteredStories[indexPath.row]
            return cell;
        }
        else if indexPath.row < stories.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell;
            cell.titleLabel?.text = stories[indexPath.row].title;

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addStoryCell", for: indexPath) as! AddTableViewCell;
            return cell
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < stories.count{
            performSegue(withIdentifier: "chapterTableSegue", sender: indexPath.row);
        }else{
            self.present(alert, animated: true, completion: nil); // Add new story
        }
    }
    
    //Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chapterTableSegue"{
            if let chapterTable = segue.destination as? ChapterTableViewController {
                if let i = sender as? Int { //row/cell i is tapped...
                    if searchActive && filteredStories.count > 0{
                        chapterTable.currentStory = stories.filter{$0.title == filteredStories[i]}[0]; //Match filtered story index with actual story in array
                    }else{
                        chapterTable.currentStory = stories[i];
                    }
                    
                }
            }
        }
    }
    

}
