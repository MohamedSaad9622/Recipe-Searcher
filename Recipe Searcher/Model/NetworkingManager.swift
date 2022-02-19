//
//  NetworkingManager.swift
//  Recipe Searcher
//
//  Created by MAC on 19/02/2022.
//

import Foundation
import Alamofire
import AlamofireImage


class NetworkingManager {
    
    static let shared = NetworkingManager()
    public func performRequest(_ url:String) {
        AF.request(url).validate().responseDecodable(of: RecipesData.self) { response in
            if let error = response.error {
                print("Error in request data\(error)")
            }else{
                let decoder = JSONDecoder()
                do{
                    let recipesData = try decoder.decode(RecipesData.self, from: response.data!)
                    Constants.shared.recipeList = recipesData.hits
                }catch{
                    print("Error in decode data\(error)")
                }
            }
        }
    }
    
}
