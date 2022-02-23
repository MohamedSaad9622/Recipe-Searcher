//
//  NetworkingManager.swift
//  Recipe Searcher
//
//  Created by MAC on 19/02/2022.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit


class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    public func performRequest(_ url:String) {
        
        AF.request(url).validate().responseDecodable(of: RecipesData.self) { response in
            if let error = response.error {
                print("Error in request data\(error)")
                Constants.shared.validateError = "\(error)"
                Constants.shared.more_recipes = false
            }else{
                let decoder = JSONDecoder()
                do{
                    let recipesData = try decoder.decode(RecipesData.self, from: response.data!)
                    // 10 because the first response has 10 recipes but when I scroll down the list we reload more than 10 recipes each time so we use this to differentiate the first search and reload more recipes
                    if recipesData.hits.count == 10 {
                        Constants.shared.recipeList = recipesData.hits
                    }else{
                        Constants.shared.recipeList += recipesData.hits
                    }
                    Constants.shared.more_recipes = recipesData.more
                    Constants.shared.recipes_Count = recipesData.count
                }catch{
                    print("Error in decode data\(error)")
                }
            }
        }
    }
    
}
