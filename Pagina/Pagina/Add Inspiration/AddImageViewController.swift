//
//  AddImageViewController.swift
//  Pagina
//
//  Created by user on 2/14/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class AddImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraImageView: UIImageView!

    
    
    
    
    let data = Data()
    var imgref: DatabaseReference!
    
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    
    //Class
    override func viewDidLoad() {
        super.viewDidLoad()
        imgref = Database.database().reference()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Camera
    
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
        cameraImageView.image =  info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func savePicture(_ sender: Any) {
        if let user = Auth.auth().currentUser{
        
            if let image = cameraImageView.image, let jpegData = UIImageJPEGRepresentation(image, 0.7){
                
                
                let ref = Database.database().reference();
                let imgName = getDate() + ".jpg";
                let storageRef = Storage.storage().reference();
                
                let imgRef = storageRef.child("userimages").child(user.uid).child(imgName);
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata){(metadata, error) in
                    guard metadata != nil else {
                        print(error ?? "unknown error")
                        return
                    }
                    print(metadata ?? "")
                    if let metadata = metadata, let url = metadata.downloadURL(){
                        ref.child("users").child(user.uid).child("stories").child(self.currentChapter.storyid).child("chapters").child(self.currentChapter.id).child("inspirations").childByAutoId().updateChildValues(["type" : "image", "url": url.absoluteString]);
                    }
                }
                self.navigationController?.popViewController(animated: true);
        }
        }
    }
            
    @IBAction func openLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //For getting a semi-unique string as a name for the image file
    func getDate() -> String{
        let date = NSDate() // Get Todays Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let stringDate: String = dateFormatter.string(from: date as Date)
        return stringDate
    }

}
