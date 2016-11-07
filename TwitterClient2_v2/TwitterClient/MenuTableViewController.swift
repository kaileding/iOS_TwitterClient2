//
//  MenuTableViewController.swift
//  TwitterClient2
//
//  Created by DINGKaile on 11/6/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    @IBOutlet var menuTable: UITableView!
    
    var menuItemIconList = ["homeline", "mentions", "jobs", "connections", "add"]
    var menuItemTitleList = ["Pulses", "Mentions", "Jobs", "Connections", "Add shortcut"]
    
    var currentMenuSelected: Int = 1
    
    var hamburgerViewController: WipeViewController!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.menuTable.dataSource = self
        self.menuTable.delegate = self
        self.menuTable.rowHeight = UITableViewAutomaticDimension
        self.menuTable.estimatedRowHeight = 50.0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "NavigatorToProfileView")
        let profileViewController = (userProfileVC as! UINavigationController).viewControllers[0] as! UserProfileViewController
        profileViewController.user = User.currentUser!
        profileViewController.navigationItem.title = "Me"
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "NavigatorToTweetsView")
        let mentionsVC = storyboard.instantiateViewController(withIdentifier: "MentionsView")
        self.viewControllers.append(userProfileVC)
        self.viewControllers.append(timelineVC)
        self.viewControllers.append(mentionsVC)
        
        self.hamburgerViewController.contentViewController = self.viewControllers[1]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.menuItemIconList.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
            (cell as! MenuItemTableViewCell).menuIcon.image = UIImage(named: self.menuItemIconList[indexPath.row-1])!
            (cell as! MenuItemTableViewCell).menuTitle.text = self.menuItemTitleList[indexPath.row-1]
            if (indexPath.row == self.currentMenuSelected) {
                (cell as! MenuItemTableViewCell).menuIcon.alpha = 1.0
                (cell as! MenuItemTableViewCell).menuTitle.alpha = 1.0
            } else {
                (cell as! MenuItemTableViewCell).menuIcon.alpha = 0.5
                (cell as! MenuItemTableViewCell).menuTitle.alpha = 0.5
            }
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != self.currentMenuSelected && indexPath.row < 3 {
            self.currentMenuSelected = indexPath.row
            self.menuTable.reloadData()
            self.hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
        self.hamburgerViewController.closeMenu()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
