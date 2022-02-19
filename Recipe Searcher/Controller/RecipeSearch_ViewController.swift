//
//  ViewController.swift
//  Recipe Searcher
//
//  Created by MAC on 18/02/2022.
//

import UIKit
import Alamofire

class RecipeSearch_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let recipes: [String] = ["mohamed","Amin"]
    let constant = Constants.shared
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}


//MARK: - UITableView

extension RecipeSearch_ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return constant.recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = constant.recipeList[indexPath.row].recipe
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.tableViewCell_Identifier, for: indexPath)
        let title = recipe.label + "\n\(recipe.source)"
        cell.textLabel?.text = title
        var healthLabels : String = ""
        for lines in recipe.healthLabels {
            healthLabels +=  lines
        }
        cell.detailTextLabel?.text = healthLabels
        let url = constant.recipeList[indexPath.row].recipe.image
        AF.request(url).responseImage { response in
//            debugPrint(response)
//            debugPrint(response.result)

            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                cell.imageView?.image = image
            }
        }
        return cell
    }
    
    
}

//MARK: - UISearchBarDelegate

extension RecipeSearch_ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchVal = searchBar.text {
            let searchLink = constant.recipeURL + searchVal
            NetworkingManager.shared.performRequest(searchLink)
            tableView.reloadData()
        }
    }
    
    
}
