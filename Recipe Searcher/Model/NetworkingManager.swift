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
        
        AF.request(url).validate(statusCode: 200..<600).responseDecodable(of: RecipesData.self) { response in
            if let error = response.error {
                print("Error in request data\(error)")
                Constants.shared.validateError = "\(error)"
            }else{
                let decoder = JSONDecoder()
                do{
                    let recipesData = try decoder.decode(RecipesData.self, from: response.data!)
                    if Constants.shared.deleteOrNo {
                        Constants.shared.recipeList = recipesData.hits
                    }else{
                        Constants.shared.recipeList += recipesData.hits
                        Constants.shared.deleteOrNo = true
                    }
                    Constants.shared.NextRecipesUrl = recipesData._links.next.href

                }catch{
                    print("Error in decode data\(error)")
                }
            }
        }
    }
    
}
