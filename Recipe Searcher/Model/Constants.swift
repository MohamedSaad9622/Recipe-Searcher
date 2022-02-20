//
//  Constants.swift
//  Recipe Searcher
//
//  Created by MAC on 18/02/2022.
//

import Foundation

class Constants {
    
    static let shared = Constants()
    
    let tableViewCell_Name = "Recipe_TableViewCell"
    let tableViewCell_Identifier = "Recipe_identifier"
    
    let recipeURL : String = "https://api.edamam.com/search?app_id=0b9d7434&app_key=356305fa04783597294427a0ded5816b&from=0&to=30&q="

    var recipeList = [Hit]()
}
