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
        
        Alamofire.request((reddit?.thumbnailSource)!).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.result)   // result of response serialization
//            print(response.data)     // server data
            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
            
            let data: Data? = response.data
            
            let image: UIImage? = UIImage(data: data!)
            
            NSLog("%@", image!)
        }
        
        imgViewThumbnail?.image = nil
        
        lblTitle?.text = reddit?.title
        
        let blackFont = [ NSForegroundColorAttributeName: UIColor.black ]
        let blueFont = [ NSForegroundColorAttributeName: UIColor.blue ]
        
        let first: NSMutableAttributedString = NSMutableAttributedString(string:"enviado el \(NSDate().getDateStringFrom(utc: (reddit?.createdUtc)!))) por ", attributes: blackFont)
        
        let second: NSMutableAttributedString = NSMutableAttributedString(string: "\(reddit?.author) ", attributes: blueFont)
        
        let three: NSMutableAttributedString = NSMutableAttributedString(string: "\(reddit?.subredditNamePrefixed))", attributes: blueFont)
        
        second.append(NSAttributedString(string: "a "))
        second.append(three)
        first.append(second)
        
        lblInfo?.attributedText = first
        
        lblCommentsCount?.text = "\(reddit?.numComments) comentarios"
    }
}
