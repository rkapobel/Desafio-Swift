//
//  RedditTableViewCell.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import Alamofire

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

    func updateCellWithReddit(_ reddit: Reddit!) {
        // MARK: do the thumbnailSource download with alamofire sdk
        
        if reddit?.thumbnailSource != nil && (reddit?.thumbnailSource.characters.count)! > 0 {
            let image: UIImage? = FileManagerExtended().getImage(withName: (reddit?.id)!, inFolder: Constants.Folders.FilesFolder.rawValue)
            
            if let letImage = image {
                imgViewThumbnail?.image = letImage
            }else {
                Alamofire.request((reddit?.thumbnailSource)!).responseJSON { response in
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
                    
                    self.imgViewThumbnail?.image = image!
                    
                    FileManagerExtended().saveFile(data: data!, withFileName: (reddit?.id)!, inFolder: Constants.Folders.FilesFolder.rawValue)
                }
            }
        }

        lblTitle?.text = reddit?.title
        
        let blackFont = [ NSForegroundColorAttributeName: UIColor.black ]
        let blueFont = [ NSForegroundColorAttributeName: UIColor.blue ]
        
        let firstStr: NSMutableAttributedString = NSMutableAttributedString(string:"enviado el \(Date().getFriedlyTimeFrom(utc: (reddit?.createdUtc)!))) por ", attributes: blackFont)
        
        let secondStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(reddit?.author) ", attributes: blueFont)
        
        let threeStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(reddit?.subredditNamePrefixed))", attributes: blueFont)
        
        secondStr.append(NSAttributedString(string: "a "))
        secondStr.append(threeStr)
        firstStr.append(secondStr)
        
        lblInfo?.attributedText = firstStr
        
        lblCommentsCount?.text = "\(reddit?.numComments) comentarios"
    }
}
