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
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    @IBOutlet weak var storyEditTextView: UITextView!
    @IBOutlet weak var inspirationCollectionView: UICollectionView!
    
    struct Inspiration {
        var type:String = ""; //"image", "map", "text"
        var id:String = "";
        
        
        //Image
        var imageUrl:String = "";
        var image: UIImage? = nil;
        
        //Map
        var long:Double = 0.0;
        var lat:Double = 0.0;
        
        //Text
        var text:String = "";
        
    }
    
    var storageRef: StorageReference!; // Firebase Storage
    var ref:DatabaseReference!; //Firebase dbs
    
    var inspirations:[Inspiration] = [];
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    // To save every so and so
    var saveTextTimer: Timer!
    var currentText = "";
    
    var userid = ""
    

    
    //Class
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let user = Auth.auth().currentUser {
            userid = user.uid;
        } else {
            // No user is signed in.
            self.dismiss(animated: true, completion: nil);  // What are you doing here? Get out!
        }
        ref = Database.database().reference();
        storageRef = Storage.storage().reference();
        fetchInspirations();
        
        navbarTitle.title = currentChapter.title;
        storyEditTextView.text = currentChapter.content;
        currentText = storyEditTextView.text;
        saveTextTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(saveText), userInfo: nil, repeats: true)
        

        //Recognize taps and hides keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        storyEditTextView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(true)
        saveTextTimer.invalidate();
        saveText();
        currentChapter.content = currentText;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Keyboard
    @objc func dismissKeyboard() {
        storyEditTextView.endEditing(true); // Hides Keyboard
    }
    
    //Save to dbs
    @objc func saveText(){
        if storyEditTextView.text != currentText{
            self.ref.child("users").child(userid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).updateChildValues(["text": self.storyEditTextView.text]);
            currentText = storyEditTextView.text;
        }
    }
    
    
    //Fetch from dbs
    func fetchInspirations(){
        ref.child("users").child(userid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).child("inspirations").observe(DataEventType.value, with: { (snapshot) in
            self.inspirations.removeAll(keepingCapacity: false);
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
                }else if inspiration.type == "image"{
                    inspiration.imageUrl = value?["url"] as? String ?? "";
                }
                
                self.inspirations.append(inspiration);
            }
            
            //fetch all images from storage
            for i in 0..<self.inspirations.count{
                if self.inspirations[i].type == "image"{
                    let storagePath = self.inspirations[i].imageUrl;
                    let imgRef = Storage.storage().reference(forURL: storagePath);
                    var image:UIImage?
                    imgRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error)
                        } else {
                            image = UIImage(data: data!) ?? nil;
                            self.inspirations[i].image = image;
                            self.inspirationCollectionView.reloadData();
                        }
                    }
                }
            }
            self.inspirationCollectionView.reloadData();
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Collection/Inspirations (Yes, we should have used a container view /similar for this)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inspirations.count + 1 // +1 for add
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item >= inspirations.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addInspirationCell", for: indexPath) as! AddInspirationCollectionViewCell
            return cell
        }
        if inspirations[indexPath.item].type == "image"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageInspirationCell", for: indexPath) as! ImageInspirationCollectionViewCell
            
            if let image = inspirations[indexPath.item].image {
                cell.image.image = image;
            }
            return cell
        }
        if inspirations[indexPath.item].type == "text"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textInspirationCell", for: indexPath) as! TextInspirationCollectionViewCell
            cell.inspirationTextView.text = inspirations[indexPath.item].text;
            return cell
        }
        if inspirations[indexPath.item].type == "map"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapInspirationCell", for: indexPath) as! MapInspirationCollectionViewCell;
            
            cell.setMap(long: inspirations[indexPath.item].long, lat: inspirations[indexPath.item].lat);
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ErrorInspirationCollectionViewCell
        cell.myLabel.text = "error"
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.size.width/3) - 5), height: collectionView.bounds.size.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item >= inspirations.count {
            //???
        }
        else if inspirations[indexPath.item].type == "image"{
            performSegue(withIdentifier: "zoomImageSegue", sender: indexPath.item)
        }
        else if inspirations[indexPath.item].type == "text"{
            performSegue(withIdentifier: "zoomTextSegue", sender: indexPath.item)
        }
        else if inspirations[indexPath.item].type == "map"{
            performSegue(withIdentifier: "zoomMapSegue", sender: indexPath.item)
        }
    }

    
    //Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addInspirationSegue" {
            if let inspiration = segue.destination as? AddInspirationViewController {
                inspiration.currentChapter = currentChapter;
            }
        }else if segue.identifier == "zoomTextSegue"{
            if let zoom = segue.destination as? TextZoomViewController {
                if let i = sender as? Int {
                    zoom.currentChapter = currentChapter;
                    zoom.currentInspiration = inspirations[i];
                }
            }
        }else if segue.identifier == "zoomMapSegue"{
            if let zoom = segue.destination as? MapZoomViewController {
                if let i = sender as? Int {
                    zoom.currentChapter = currentChapter;
                    zoom.currentInspiration = inspirations[i];
                }
            }
        }else if segue.identifier == "zoomImageSegue"{
            if let zoom = segue.destination as? ImageZoomViewController {
                if let i = sender as? Int {
                    zoom.currentChapter = currentChapter;
                    zoom.currentInspiration = inspirations[i];
                }
            }
        }
    }
 

}
