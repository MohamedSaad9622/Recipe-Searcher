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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    // filter buttons
    @IBOutlet weak var All_FilterButton: UIButton!
    @IBOutlet weak var lowSugarFilter: UIButton!
    @IBOutlet weak var ketoFilter: UIButton!
    @IBOutlet weak var veganFilter: UIButton!
    
    
    let constant = Constants.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // to register custom cell for tableView
        tableView.register(UINib(nibName: constant.tableViewCell_Name, bundle: nil), forCellReuseIdentifier: constant.tableViewCell_Identifier)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        NetworkingManager.shared.delegate = self
    }
    

//MARK: - Filter Buttons
    
    @IBAction func AllButtonFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            handleSelected_Button(All_FilterButton.tag)
            // if the user write recipe name in search bar and press filter in this case constant.recipeUrl_searchText is empty so we write this
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                NetworkingManager.shared.performRequest(self.constant.recipeUrl_searchText)
            }else{
                NetworkingManager.shared.performRequest(constant.recipeUrl_searchText)
                }
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func lowSugarFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            handleSelected_Button(lowSugarFilter.tag)
            // if the user write recipe name in search bar and press filter in this case constant.recipeUrl_searchText is empty
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                NetworkingManager.shared.performRequest(self.constant.recipeUrl_searchText + constant.lowSugar_filter)
            }else{
                NetworkingManager.shared.performRequest(constant.recipeUrl_searchText + constant.lowSugar_filter)
            }

        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func ketoFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            handleSelected_Button(ketoFilter.tag)
            // if the user write recipe name in search bar and press filter in this case constant.recipeUrl_searchText is empty
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                NetworkingManager.shared.performRequest(self.constant.recipeUrl_searchText + constant.keto_filter)
            }else{
                NetworkingManager.shared.performRequest(constant.recipeUrl_searchText + constant.keto_filter)
            }
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func vegan(_ sender: UIButton) {
        if searchBar.text != "" {
            handleSelected_Button(veganFilter.tag)
            // if the user write recipe name in search bar and press filter in this case constant.recipeUrl_searchText is empty
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                NetworkingManager.shared.performRequest(constant.recipeUrl_searchText + constant.vegan_filter)

            }else{
                NetworkingManager.shared.performRequest(constant.recipeUrl_searchText + constant.vegan_filter)
            }
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
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

        if indexPath.row == constant.recipeList.count - 1 {
            // to add to the recipesList without delete previous recipes in it
            constant.deleteOrNo = false
            NetworkingManager.shared.performRequest(constant.NextRecipesUrl)
            }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        constant.recipeIndex = indexPath.row
        // to open RecipeDetails_ViewController programmatically
        let storyBoard = UIStoryboard(name: constant.RecipeDetails_storyboardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: constant.RecipeDetails_Id) as! RecipeDetails_ViewController
        navigationController?.pushViewController(newViewController, animated: false)
    }
    
}

//MARK: - UISearchBarDelegate

extension RecipeSearch_ViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var searchVal = searchBar.text {
            // to remove selected filter button
            handleSelected_Button(nil)
            // to remove space before text
            searchVal = searchVal.trimmingCharacters(in: .whitespacesAndNewlines)
            // handle empty search bar
            if searchVal.isEmpty {
                handleAlertMessage(constant.handleEmpty_searchBar)
                searchBar.text = ""
                }
                else{
                    constant.recipeUrl_searchText = constant.recipeURL + searchVal
                    NetworkingManager.shared.performRequest(constant.recipeUrl_searchText)
                }
            }
        }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        do {
            //only english letters & spaces are allowed to be inserted in the search bar
            if let searchVal = searchBar.text {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: searchVal, options: [], range: NSMakeRange(0, searchVal.count)) != nil {
                    // show alert message
                    handleAlertMessage(constant.handleAllowedIn_searchBar)
                    // to make search bar empty
                    searchBar.text = ""
                    searchBar.resignFirstResponder()
                    return false
                }
            }
        }
        catch {
            print(error)
        }
        return true
    }
    
    
}

//MARK: - Update UI

extension RecipeSearch_ViewController : NetworkManagerDelegate{
    
    func didUpdateRecipse(recipesData: RecipesData?) {
        DispatchQueue.main.async {
            if let recipesData = recipesData {
                if Constants.shared.deleteOrNo {
                    Constants.shared.recipeList = recipesData.hits
                }else{
                    Constants.shared.recipeList += recipesData.hits
                    Constants.shared.deleteOrNo = true
                }
                Constants.shared.NextRecipesUrl = recipesData._links.next.href
            }
            self.tableView.reloadData()
        }
    }

    
    func handleAlertMessage(_ reason:String) {
        
        let alert = UIAlertController(title: "Warning!", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func handleSelected_Button(_ buttonTag:Int?) {
        switch buttonTag{
        // 0 -> Tag of All filter button
        case 0:
            All_FilterButton.isSelected = true
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
        // 1 -> Tag of Low Sugar filter button
        case 1:
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = true
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
        // 2 -> Tag of ketofilter button
        case 2:
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = true
            veganFilter.isSelected = false
        // 3 -> Tag of vegan filter button
        case 3:
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = true
        default:
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
            
        }
    }
}
