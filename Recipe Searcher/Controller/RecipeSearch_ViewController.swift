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
    
    
    let constant = Constants.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // to register custom cell for tableView
        tableView.register(UINib(nibName: constant.tableViewCell_Name, bundle: nil), forCellReuseIdentifier: constant.tableViewCell_Identifier)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.tableViewCell_Identifier, for: indexPath) as! Recipe_TableViewCell
        
        cell.recipeTitle.text = recipe.label
        cell.recipeSource.text = recipe.source
        // to show all health labels in only one label
        for lines in recipe.healthLabels {
            cell.recipeHealthLabels.text! +=  lines
        }
        
        // to show the image from its url
        let url = constant.recipeList[indexPath.row].recipe.image
        AF.request(url).responseImage { response in
            if case .success(let image) = response.result {
                cell.recipeImage.image = image
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
