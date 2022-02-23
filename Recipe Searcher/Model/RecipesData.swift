//
//  RecipesData.swift
//  Recipe Searcher
//
//  Created by MAC on 19/02/2022.
//

import Foundation

struct RecipesData : Codable {
    let hits : [Hit]
    let more : Bool
    let count : Int
}

struct Hit : Codable{
    let recipe : Recipe
}
struct Recipe : Codable{
    let image : String
    let label : String
    let source :String
    let healthLabels : [String]
    let url : String
    let ingredientLines : [String]
}
