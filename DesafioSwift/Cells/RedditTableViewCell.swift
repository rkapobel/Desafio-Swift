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

    func updateCell(withReddit reddit: NSManagedObject) {
        let redditManaged: RedditManaged = RedditManaged(withManagedObject: reddit)
        
        var thumbnailSourceValue: String = redditManaged.getThumbnailSource()
        thumbnailSourceValue = redditManaged.getThumbnailSource()
        let idValue: String = redditManaged.getId()
        let authorValue: String = redditManaged.getAuthor()
        let titleValue: String = redditManaged.getTitle()
        let createdUtcValue: Double = redditManaged.getCreatedUtc()
        let subredditNamePrefixedValue: String = redditManaged.getSubrreditNamePrefixed()
        let numCommentsValue: UInt32 = redditManaged.getNumComments()
        
        if thumbnailSourceValue.characters.count > 0 {
            let image: UIImage? = FileManager().getImage(withName: idValue, inFolder: Constants.FilesFolder)
            
            if let letImage = image {
                imgViewThumbnail?.image = letImage
            }else {
                Alamofire.request(thumbnailSourceValue).responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // HTTP URL response
//                    print(response.result)   // result of response serialization
//                    print(response.data)     // server data
//                    
                    
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
                    
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
        
        let firstStr: NSMutableAttributedString = NSMutableAttributedString(string:"enviado el \(Date().getFriedlyTime(fromUtc:Float(createdUtcValue))) por ", attributes: blackFont)
        
        let secondStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(authorValue) ", attributes: blueFont)
        
        let threeStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(subredditNamePrefixedValue))", attributes: blueFont)
        
        secondStr.append(NSAttributedString(string: "a "))
        secondStr.append(threeStr)
        firstStr.append(secondStr)
        
        lblInfo?.attributedText = firstStr
        
        lblCommentsCount?.text = "\(numCommentsValue) comentarios"
    }
}
