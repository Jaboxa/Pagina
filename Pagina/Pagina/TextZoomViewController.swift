//
//  TextZoomViewController.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-15.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit

class TextZoomViewController: UIViewController {

    @IBOutlet weak var inspirationTextView: UITextView!
   
    var currentInspiration: StoryEditViewController.Inspiration = StoryEditViewController.Inspiration();
    var currentChapter: ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inspirationTextView.text = currentInspiration.text;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
