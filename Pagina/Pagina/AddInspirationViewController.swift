//
//  AddInspirationViewController.swift
//  Pagina
//
//  Created by user on 2/11/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit

class AddInspirationViewController: UIViewController{
    
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMapSegue" {
            if let inspiration = segue.destination as? AddMapViewController {
                inspiration.currentChapter = currentChapter;
            }
        }else if segue.identifier == "addTextSegue" {
            if let inspiration = segue.destination as? AddTextInspirationViewController {
                inspiration.currentChapter = currentChapter;
            }
        }else if segue.identifier == "addImageSegue" {
            if let inspiration = segue.destination as? AddImageViewController {
                 inspiration.currentChapter = currentChapter;
            }
        }
    }
 

}
