//
//  UIImageViewExtended.swift
//  DesafioSwift
//
//  Created by The App Master on 31/12/00.
//  Copyright © 2000 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

extension UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateImage(withSource source: String, andId idValue: String) {
        if source.characters.count > 0 {
            let image: UIImage? = FileManager().getImage(withName: idValue, inFolder: Constants.FilesFolder)
            
            if let letImage = image {
                self.image = letImage
            }else {
                Alamofire.request(source).responseJSON { response in
                    let data: Data? = response.data
                    
                    let image: UIImage? = UIImage(data: data!)
                    
                    if let letImage2 = image {
                        self.image = letImage2
                        FileManager().saveFile(data: data!, withFileName: idValue, inFolder: Constants.FilesFolder)
                    }else {
                        self.image = UIImage(imageLiteralResourceName: "no-image")
                    }
                }
            }
        }
    }
}
