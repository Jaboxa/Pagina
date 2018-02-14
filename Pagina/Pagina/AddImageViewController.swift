//
//  AddImageViewController.swift
//  Pagina
//
//  Created by user on 2/14/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated:true, completion: nil)
    }
    
    
    @IBAction func savePicture(_ sender: Any) {
        if let img =  cameraImageView.image {
                      UIImageWriteToSavedPhotosAlbum( img , nil, nil, nil)
            
            cameraImageView.image = nil
            
            
            //det här är fel. Det ska sparas i storage i firebase
            //och visas i den sista slotten i collectionview
            //visa den i arrayen. spara den till arrayen
            }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
    }


    override func viewDidLoad() {
        super.viewDidLoad()

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
