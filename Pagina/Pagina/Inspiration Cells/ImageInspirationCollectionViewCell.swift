//
//  ImageInspirationCollectionViewCell.swift
//  Pagina
//
//  Created by user on 2/11/18.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit

class ImageInspirationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Resize for cell
        image.sizeToFit();
        image.contentMode = UIViewContentMode.scaleAspectFill;
    }
    
}
