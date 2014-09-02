//
//  ViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-1.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let newsHelper = NewsHelper()
    var tableData:[[String:AnyObject]] = []
                            
    @IBOutlet var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        newsHelper.getList(){(data:[[String:AnyObject]]) in
            println(data)
            self.tableData = data
            self.newsTableView!.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("hits")
        return tableData.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel.text = rowData["title"] as String
        cell.detailTextLabel.text = rowData["summary"] as String
        
        return cell
    }

}

