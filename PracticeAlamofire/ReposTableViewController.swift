//
//  ViewController.swift
//  PracticeAlamofire
//
//  Created by Arvin San Miguel on 11/1/16.
//  Copyright © 2016 AppRising. All rights reserved.
//

import UIKit
import Alamofire

class ReposTableViewController: UITableViewController {
    
    var store = ReposDataStore.sharedInstance
    var inputTextField : UITextField!
    var searchedItem : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = store.repositories[indexPath.row]
        
        store.toggleStarStatus(for: repository, completion: { status in
            self.showAlert(status: status, user: repository.fullName )
        })
        
    }
    
    
    @IBAction func searchGitRepo(_ sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Enter Repositories", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField: UITextField!) in
            
            textField.placeholder = "Search here"
            self.inputTextField = textField
            
        })
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.searchedItem = self.inputTextField.text
            self.searchRepo()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func searchRepo() {
        if let searchItem = searchedItem {
            store.displaySearchedRepos(of: searchItem, completion: {
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            })
        }
    }
  
    func showAlert(status: Bool, user: String) {
        let message : String
        if status {
            message = "You just starred \(user)"
        } else {
            message = "You just unstarred \(user)"
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}

