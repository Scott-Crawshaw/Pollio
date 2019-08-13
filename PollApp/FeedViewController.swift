//
//  FeedViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/13/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {

    var data : [[String : Any]] = []
    var totalCount = 0
    var refresh = false
    let initialGet = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
