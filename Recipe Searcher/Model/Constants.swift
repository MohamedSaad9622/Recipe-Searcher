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

    let RecipeDetails_storyboardName = "RecipeDetails_Storyboard"
    let RecipeDetails_Id = "RecipeDetails_Id"
    
    //MARK: - recipes url
    
    // recipe Url before add search text
    let recipeURL : String = "https://api.edamam.com/api/recipes/v2?type=public&app_id=9cb782c6&app_key=8eb67ee2cdc935077765efdb928656c5&q="

    // recipe Url after add search text
    var recipeUrl_searchText : String = ""
    
    var NextRecipesUrl : String = ""
    
    //MARK: - recipes data

    var recipeList = [Hit]()
    // to send recipe index to RecipeDtails_ViewController to get data there
    var recipeIndex : Int?
    // if search from pagination add to recipesList else reWrite
    var deleteOrNo : Bool = true
    
    // filter text
    let lowSugar_filter = "&health=low-sugar"
    let keto_filter = "&health=keto-friendly"
    let vegan_filter = "&health=vegan"
    
    //MARK: -  messages for Alert view
    
    let handleEmpty_searchBar = "Please write Recipe name in search bar"
    let handleAllowedIn_searchBar  = "Only English letters & spaces are allowed to be inserted in the search"
    let handleNoRecipes = "There is no Recipes by this name"
    
    // to share error message between NetworkinManager and RecipeSearch_ViewController
    var validateError : String?
}
