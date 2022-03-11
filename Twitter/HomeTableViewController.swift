//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Enrique Bercian on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    var tweetArray = [NSDictionary]()
    var numTweets: Int!
    
    let tweetRefreshControl = UIRefreshControl()
    
    @objc func loadTweets() {
        
        numTweets = 20
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams, success: { (tweets :[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Error: Could not get tweets")
        })
    }
    
    func loadMoreTweets () {
        
        numTweets += 20
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams, success: { (tweets :[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Error: Could not get tweets")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
            
//        let twitterBlueColor = UIColor(red: 20, green: 77, blue: 150, alpha: 0)
//        if #available(iOS 13.0, *) {
//            let navBar = UINavigationBarAppearance()
//            navBar.configureWithOpaqueBackground()
//            navBar.titleTextAttributes = [.foregroundColor : UIColor.white]
//            navBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
//            navBar.backgroundColor = twitterBlueColor
//            navigationItem.standardAppearance = navBar
//            navigationItem.scrollEdgeAppearance = navigationItem.standardAppearance
//        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let userData = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageUrl = URL(string: (userData["profile_image_url_https"] as? String)!)
        let imageData = try? Data(contentsOf: imageUrl!)
        
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String
        cell.usernameLabel.text = userData["name"] as? String
        
        if (imageData != nil){
            cell.profileImageView.image = UIImage(data: imageData!)
        }
        
        
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
