//
//  wController.swift
//  Pagina
//
//  Created by user on 2/8/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class StoryEditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var inspirations:[Inspiration] = [];
    
    struct Inspiration{
        var type:String = ""; //"image", "map", "text"
        var id:String = "";
        
        
        //Image
        var imageurl:String = "";
        
        //Map
        var long:Double = 0.0;
        var lat:Double = 0.0;
        
        //Text
        var text:String = "";
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inspirations.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item >= inspirations.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addInspirationCell", for: indexPath) as! AddInspirationCollectionViewCell
            return cell
        }
        if inspirations[indexPath.item].type == "image"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageInspirationCell", for: indexPath) as! ImageInspirationCollectionViewCell
            //cell.image.image = #imageLiteral(resourceName: "cat")
        
            cell.image.contentMode = UIViewContentMode.scaleAspectFill
            
            return cell
        }
        if inspirations[indexPath.item].type == "text"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textInspirationCell", for: indexPath) as! textCollectionViewCell
            cell.inspirationTextView.text = inspirations[indexPath.item].text;
            return cell
        }
        if inspirations[indexPath.item].type == "map"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapInspirationCell", for: indexPath) as! MapCollectionViewCell;
            print("map");
            
            cell.setMap(long: inspirations[indexPath.item].long, lat: inspirations[indexPath.item].lat);
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! inspirationsCollectionViewCell
        cell.myLabel.text = "x"
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("UUUUUUSH");
        return CGSize(width: ((collectionView.bounds.size.width/3) - 5), height: collectionView.bounds.size.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //var minimumLineSpacing: CGFloat { get set }
        return CGFloat(5);
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item >= inspirations.count {
        //???
        }
//        if inspirations[indexPath.item].type == "image"{
//
//        }
        else if inspirations[indexPath.item].type == "text"{
            performSegue(withIdentifier: "zoomTextSegue", sender: indexPath.item)
        }
        else if inspirations[indexPath.item].type == "map"{
            performSegue(withIdentifier: "zoomMapSegue", sender: indexPath.item)
        }
    }
    
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var savingStatusLabel: UILabel!
    @IBOutlet weak var storyEditTextView: UITextView!

    @IBOutlet weak var inspirationCollectionView: UICollectionView!
    
    
    var saveTextTimer: Timer!
    var ref:DatabaseReference!
    var userid = "user"
    var currentText = "";

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            userid = user.uid;
            print(userid);
            
        } else {
            // No user is signed in.
            // ...
        }
        ref = Database.database().reference();
        fetchInspirations();
        navbarTitle.title = currentChapter.title;
        storyEditTextView.text = currentChapter.content;
        currentText = storyEditTextView.text;
        saveTextTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(saveText), userInfo: nil, repeats: true)
        savingStatusLabel.text = "";
    }
    
    
    func fetchInspirations(){
        inspirations.removeAll(keepingCapacity: false);
        ref.child("users").child(userid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).child("inspirations").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary;
                var inspiration = Inspiration();
                inspiration.type = value?["type"] as? String ?? "";
                inspiration.id = child.key;
                if inspiration.type == "text"{
                    inspiration.text = value?["text"] as? String ?? "";
                }else if inspiration.type == "map"{
                    inspiration.long = value?["long"] as? Double ?? 0.0;
                    inspiration.lat = value?["lat"] as? Double ?? 0.0;
                }
                
                self.inspirations.append(inspiration);
            }
            self.inspirationCollectionView.reloadData();
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
        savingStatusLabel.text = "saving....";
        if storyEditTextView.text != currentText{
        self.ref.child("users").child(userid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).updateChildValues(["text": self.storyEditTextView.text]);
            currentText = storyEditTextView.text;
            savingStatusLabel.text = "saved!";
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addInspirationSegue" {
            if let inspiration = segue.destination as? AddInspirationViewController {
                inspiration.currentChapter = currentChapter;
            }
        }
    }
 

}
