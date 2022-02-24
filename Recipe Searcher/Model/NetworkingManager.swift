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

// used to send data to RecipesSearch_ViewController to update the ui
protocol NetworkManagerDelegate {
    func didUpdateRecipse(recipesData:RecipesData?)
    func handleAlertMessage(_ reason:String)
}

class NetworkingManager {
    
    static let shared = NetworkingManager()
    var delegate : NetworkManagerDelegate?
    
    public func performRequest(_ url:String) {
        
        AF.request(url).validate().responseDecodable(of: RecipesData.self) { response in
            if let error = response.error {
                self.delegate?.handleAlertMessage(error.localizedDescription)
            }else{
                let decoder = JSONDecoder()
                do{
                    let recipesData = try decoder.decode(RecipesData.self, from: response.data!)
                    self.delegate?.didUpdateRecipse(recipesData: recipesData)
                }catch{
                    print("Error in decode data\(error)")
                }
            }
        }
    }
    
}
