//
//  RedditTableViewCell.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class RedditTableViewCell: UITableViewCell {
    
    @IBOutlet var imgViewThumbnail: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblInfo: UILabel!
    
    @IBOutlet var lblCommentsCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.text = "..."
        lblInfo.text = "..."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     Ingrando una entidad Reddit, la función se encarga de actualizar los datos de la misma.
    */
    func updateCell(withReddit reddit: Reddit) {
        
        var thumbnailSourceValue: String = reddit.thumbnailSource!
        let idValue: String = reddit.id!
        let authorValue: String = reddit.author!
        let titleValue: String = reddit.title!
        let createdUtcValue: Double = reddit.createdUtc
        let subredditNamePrefixedValue: String = reddit.subredditNamePrefixed!
        let numCommentsValue: UInt32 = UInt32(reddit.numComments)
        
        if thumbnailSourceValue.characters.count > 0 {
            let image: UIImage? = FileManager().getImage(withName: idValue, inFolder: Constants.FilesFolder)
            
            if let letImage = image {
                imgViewThumbnail?.image = letImage
            }else {
                Alamofire.request(thumbnailSourceValue).responseJSON { response in
                    let data: Data? = response.data
                    
                    let image: UIImage? = UIImage(data: data!)
                    
                    if let letImage2 = image {
                        self.imgViewThumbnail?.image = letImage2
                        FileManager().saveFile(data: data!, withFileName: idValue, inFolder: Constants.FilesFolder)
                    }else {
                        self.imgViewThumbnail?.image = UIImage(imageLiteralResourceName: "no-image")
                    }
                }
            }
        }

        lblTitle?.text = titleValue
        
        let blackFont = [ NSForegroundColorAttributeName: UIColor.black ]
        let blueFont = [ NSForegroundColorAttributeName: UIColor.blue ]
        
        let firstStr: NSMutableAttributedString = NSMutableAttributedString(string:"Enviado \(Date().getFriedlyTime(fromUtc:createdUtcValue)) por ", attributes: blackFont)
        
        let secondStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(authorValue) ", attributes: blueFont)
        
        let threeStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(subredditNamePrefixedValue))", attributes: blueFont)
        
        secondStr.append(NSAttributedString(string: "a "))
        secondStr.append(threeStr)
        firstStr.append(secondStr)
        
        lblInfo?.attributedText = firstStr
        
        lblCommentsCount?.text = "\(numCommentsValue) comentarios"
    }
}
