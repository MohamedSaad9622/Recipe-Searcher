//
//  RecipeDetails_ViewController.swift
//  Recipe Searcher
//
//  Created by MAC on 21/02/2022.
//

import UIKit
import Alamofire
import AlamofireImage
import SafariServices

class RecipeDetails_ViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipe_ingredients: UILabel!
    
    var recipeWebUrl : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if let recipeIndex = Constants.shared.recipeIndex{
            let recipe = Constants.shared.recipeList[recipeIndex].recipe
            recipeTitle.text = recipe.label
            // to show Recipe ingredients each on a separate line
            var ingrdients = recipe.ingredientLines[0]
            for lins in recipe.ingredientLines {
                ingrdients += "\n\(lins)"
            }
            recipe_ingredients.text = ingrdients
            
            recipeWebUrl = recipe.url
            // to show recipe image 
            let url = recipe.image
            AF.request(url).responseImage { response in
                if case .success(let image) = response.result {
                    self.recipeImage.image = image
                }
            }
        }
    }
    
    // to go to the recipe website
    @IBAction func recipeWeb_isPressed(_ sender: UIButton) {
        if let url = URL(string: recipeWebUrl){
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    // to share recipe link
    @IBAction func shareButton_IsPressed(_ sender: UIBarButtonItem) {
        let vc = UIActivityViewController(activityItems: [Constants.shared.recipeURL], applicationActivities: [])
        present(vc, animated: true)
    }
}
