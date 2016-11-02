//
//  GithubAPIClient.swift
//  PracticeAlamofire
//
//  Created by Arvin San Miguel on 11/1/16.
//  Copyright © 2016 AppRising. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONDictionary = [String : Any]

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([JSONDictionary]) -> ()) {
        
        let url = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        Alamofire.request(url).responseJSON(completionHandler: { response in
            if let JSON = response.result.value {
                let responseJSON = JSON as! [JSONDictionary]
                completion(responseJSON)
            }
        })
        
    }
    
    class func checkIfRepositoryIsStarred(_ fullName: String, with completion: @escaping (Bool) -> ()) {
        
        let url = "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.personalToken)"
        Alamofire.request(url).responseJSON(completionHandler: { response in
            if response.response?.statusCode == 204 {
                OperationQueue.main.addOperation { completion(true) } }
            else if response.response?.statusCode == 404 {
                OperationQueue.main.addOperation { completion(false) } }
        })
        
    }
    
    class func starRepository(named: String, completion: @escaping () -> ()) {
        
        let url  = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(named)?access_token=\(Secrets.personalToken)")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        Alamofire.request(request).responseJSON(completionHandler: { response in
            if response.response?.statusCode == 204 {
                OperationQueue.main.addOperation { completion() } }
            else if response.response?.statusCode == 404 {
                OperationQueue.main.addOperation { completion() } }
        })
        
    }
    
    class func unstarRepository(named: String, completion: @escaping () -> ()) {
        
        let url  = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(named)?access_token=\(Secrets.personalToken)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        Alamofire.request(request).responseJSON(completionHandler: { response in
            if response.response?.statusCode == 204 {
                OperationQueue.main.addOperation { completion() } }
            else if response.response?.statusCode == 404 {
                OperationQueue.main.addOperation { completion() } }
        })
        
    }
    
    class func searchRepository(item: String, completion: @escaping (JSONDictionary) -> ()) {
        
        let url = "\(Secrets.githubAPIURL)/search/repositories?q=\(item)&access_token=\(Secrets.personalToken)"
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            if let JSON = response.result.value {
                let responseJSON = JSON as! JSONDictionary
                completion(responseJSON)
            }
        })
        
    }
    
    
    
}
