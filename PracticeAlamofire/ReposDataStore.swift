//
//  ReposDataStore.swift
//  PracticeAlamofire
//
//  Created by Arvin San Miguel on 11/1/16.
//  Copyright © 2016 AppRising. All rights reserved.
//

import Foundation

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories : [GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        
        GithubAPIClient.getRepositories(with: { reposArray in
            
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
            }
            completion()
                 
        })
    }
    
    func toggleStarStatus(for user: GithubRepository, completion: @escaping (_ starred: Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(user.fullName, with: { status in
            
            if status {
                GithubAPIClient.unstarRepository(named: user.fullName, completion: {
                    OperationQueue.main.addOperation {
                        completion(false)
                    }
                })
            } else {
                GithubAPIClient.starRepository(named: user.fullName, completion: {
                    OperationQueue.main.addOperation {
                        completion(true)
                    }
                })
            }
            
        })
        
    }
    
    func displaySearchedRepos(of searchedItem: String, completion: @escaping () -> ()) {
        
        GithubAPIClient.searchRepository(item: searchedItem, completion: { dictionary in
            
            self.repositories.removeAll()
            guard let repos = dictionary["items"] as? [JSONDictionary] else { fatalError() }
            for repo in repos {
                
                self.repositories.append(GithubRepository.init(dictionary: repo))
                
            }
            completion()
        })
    }

}

