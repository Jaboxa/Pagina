//
//  wController.swift
//  Pagina
//
//  Created by user on 2/8/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit

class StoryEditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
       var items = ["1","2","3","4","5","6","7","8","9"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! inspirationsCollectionViewCell
        
        cell.myLabel.text = items[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    

    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var storyEditTextView: UITextView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navbarTitle.title = currentChapter.title;
        storyEditTextView.text = currentChapter.content;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
