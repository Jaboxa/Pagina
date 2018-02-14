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
    
    var currentChapter:ChapterTableViewController.Chapter = ChapterTableViewController.Chapter();
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    
    let data = Data()
    var imgref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgref = Database.database().reference()
        

    
    }
    
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
        
//        if let img =  cameraImageView.image {
//            UIImageWriteToSavedPhotosAlbum( img , nil, nil, nil)
        
        
        if let user = Auth.auth().currentUser{
            let ref = Database.database().reference();
            ref.child("users").child(user.uid).child("stories").child(currentChapter.storyid).child("chapters").child(currentChapter.id).child("inspirations").childByAutoId().updateChildValues(["type" : "image"]);
        
            if let image = cameraImageView.image, let jpegData = UIImageJPEGRepresentation(image, 0.7){
                
                let imgName = "inspirationimage.jpg"
                
                
                let imgstorage = Storage.storage().reference()
                let imgRef = imgstorage.child(imgName)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata){(metadata, error) in
                    guard metadata != nil else {
                        print(error)
                        return
                    }
                    print(metadata)
                }
        }
        }
    }
            
    @IBAction func openLibrary(_ sender: Any) {
        
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
