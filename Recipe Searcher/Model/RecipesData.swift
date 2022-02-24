//
//  RecipesData.swift
//  Recipe Searcher
//
//  Created by MAC on 19/02/2022.
//

import Foundation

struct RecipesData : Codable {
    let hits : [Hit]
    let _links : Links
}
struct Links : Codable {
    let next : Next
}
struct Next : Codable {
    let href : String
    let title : String
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
