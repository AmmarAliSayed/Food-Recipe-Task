//
//  NetworkService.swift
//  SoftxpertTask
//
//  Created by Macbook on 27/01/2022.
//

import Foundation
import Alamofire
class NetworkService {
func getRecipesFromAPI(of searchText:String,health:String?,completion:@escaping (([Recipe]?,Error?)->()))
    {
       var url:String?
        let encodedURL = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    let query = "?app_id=\(URLs.appId)&app_key=\(URLs.appKey)&q=\(encodedURL!)"
    let urlString = "\(URLs.baseUrl )\(query)"
    
        if health == nil {
            url = urlString
        }
        else{
            url = "\(urlString)&health=\(health!)"
        }
        AF.request(url!,encoding: URLEncoding(destination: .queryString))
            .validate()
            .responseDecodable(of: RecipeModel.self){
                (response) in
                switch response.result
                {
                case .success(_) :
                    guard let recipe = response.value else {
                        return
                    }
                    completion(recipe.hits,nil)
                case .failure(let error):
                    
                    completion(nil,error)
                }
            }
    }
}
