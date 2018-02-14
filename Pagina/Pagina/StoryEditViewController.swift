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
    
    var items = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    var inspirations:[Inspiration] = [];
    
    struct Inspiration{
        var type:String = "";
        var imageurl:String = "";
        var location:String = "";
        var storyText:String = "";
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
            cell.inspirationTextView.text = "Blablabla"
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
        print("blä")
    }
    
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var savingStatusLabel: UILabel!
    @IBOutlet weak var storyEditTextView: UITextView!

    var saveTextTimer: Timer!
    var ref:DatabaseReference!
    var userid = "user"
    var currentText = "";

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inspirations
        for i in 0..<8{
            var insp = Inspiration();
            if i % 2 == 0{
                insp.type = "image";
            }else{
                insp.type = "text";
            }
    
            inspirations.append(insp);
        }
        
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
        savingStatusLabel.text = "";
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addInspirationSegue" {
            if let inspiration = segue.destination as? AddInspirationViewController {
                inspiration.currentChapter = currentChapter;
            }
        }
    }
 

}
