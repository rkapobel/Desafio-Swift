//
//  ViewController.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblReddits: UITableView!
    
    var reddits: [NSManagedObject] = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblReddits.estimatedRowHeight = 80
        tblReddits.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: Elijo actualizar siempre que la vista aparece. Los reddits cambian eventualmente.
        
        ServiceDataManager().updateReddits { (redditsIn: [NSManagedObject]?) in
            if let letRedditsIn = redditsIn {
                self.reddits = letRedditsIn
                DispatchQueue.main.async {
                    self.tblReddits.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: cell no puede ser nil si el storyboard esta bien configurado
        
        let cell: RedditTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedditTableViewCell.self), for: indexPath) as! RedditTableViewCell
 
        let reddit: NSManagedObject = reddits[indexPath.row] as! Reddit
    
        cell.updateCell(withReddit: reddit)
        
        return cell
    }
}

