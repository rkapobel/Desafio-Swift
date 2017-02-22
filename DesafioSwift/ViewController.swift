//
//  ViewController.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblReddits: UITableView!
    
    var reddits: Array<Reddit> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblReddits.estimatedRowHeight = 120
        tblReddits.rowHeight = UITableViewAutomaticDimension
        
        ServiceDataManager().updateReddits { (redditsIn: Array<Reddit>?) in
            if let letRedditsIn = redditsIn {
                self.reddits += letRedditsIn
                DispatchQueue.main.async {
                    self.tblReddits.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: no puede ser nil asi que...
        
        let cell: RedditTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedditTableViewCell.self), for: indexPath) as! RedditTableViewCell

        return cell
    }
}

