//
//  RedditTableViewCell.swift
//  DesafioSwift
//
//  Created by Rodrigo Kapobel on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

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
        
        // MARK: Las entidades no tienen valores en nil. Una entidad se inicializa si o si con algun valor a pesar de que los parámetros son optionals.
        
        let thumbnailSourceValue: String = reddit.thumbnailSource!
        let idValue: String = reddit.id!
        let authorValue: String = reddit.author!
        let titleValue: String = reddit.title!
        let createdUtcValue: Double = reddit.createdUtc
        let subredditNamePrefixedValue: String = reddit.subredditNamePrefixed!
        let numCommentsValue: UInt32 = UInt32(reddit.numComments)
        
        self.imgViewThumbnail.updateImage(withSource: thumbnailSourceValue, andId: idValue)

        lblTitle?.text = titleValue
        
        updateInfo(withCreatedUtc: createdUtcValue, authorValue: authorValue, andSubredditNamePrefixedValue: subredditNamePrefixedValue)
    
        lblCommentsCount?.text = "\(numCommentsValue) comentarios"
    }
    
    func updateInfo(withCreatedUtc createdUtcValue: Double,
                    authorValue: String,
                    andSubredditNamePrefixedValue subredditNamePrefixedValue: String) {
        let blackFont = [ NSForegroundColorAttributeName: UIColor.black ]
        let blueFont = [ NSForegroundColorAttributeName: UIColor.blue ]
        
        let firstStr: NSMutableAttributedString = NSMutableAttributedString(string:"Enviado \(Date().getFriedlyTime(fromUtc:createdUtcValue)) por ", attributes: blackFont)
        
        let secondStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(authorValue) ", attributes: blueFont)
        
        let thirthStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(subredditNamePrefixedValue))", attributes: blueFont)
        
        secondStr.append(NSAttributedString(string: "a "))
        secondStr.append(thirthStr)
        firstStr.append(secondStr)
        
        lblInfo?.attributedText = firstStr
    }
}
