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
        scrollView.showsHorizontalScrollIndicator = true
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func AllButtonFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            constant.filter_text = ""
            handleSelected_Button(All_FilterButton.tag)
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                updateUI(with: self.constant.recipeUrl_searchText)
            }else{
                updateUI(with: constant.recipeUrl_searchText )
                }
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func lowSugarFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            constant.filter_text = "&health=low-sugar"
            handleSelected_Button(lowSugarFilter.tag)
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                updateUI(with: self.constant.recipeUrl_searchText + constant.filter_text)
            }else{
                updateUI(with: constant.recipeUrl_searchText + constant.filter_text)
            }
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func ketoFilter_isPressed(_ sender: UIButton) {
        if searchBar.text != "" {
            constant.filter_text = "&health=keto"
            handleSelected_Button(ketoFilter.tag)
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                updateUI(with: self.constant.recipeUrl_searchText + constant.filter_text)
            }else{
                updateUI(with: constant.recipeUrl_searchText + constant.filter_text)
            }
            /* because this filter are not allowed for my account as developer
                this is link to test
             https://api.edamam.com/search?app_id=9cb782c6&app_key=8eb67ee2cdc935077765efdb928656c5&q=fish&health=keto
             */
            handleAlertMessage("The following filters are not allowed for this level: keto")
            handleSelected_Button(nil)
        }else{
            handleAlertMessage(constant.handleEmpty_searchBar)
        }
    }
    @IBAction func vegan(_ sender: UIButton) {
        if searchBar.text != "" {
            constant.filter_text = "&health=vegan"
            handleSelected_Button(veganFilter.tag)
            if constant.recipeUrl_searchText == ""{
                constant.recipeUrl_searchText += constant.recipeURL + searchBar.text!
                updateUI(with: self.constant.recipeUrl_searchText + constant.filter_text)
            }else{
                updateUI(with: constant.recipeUrl_searchText + constant.filter_text)
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
        print("^^^^^^^^^^^more = \(constant.more_recipes)")
        if indexPath.row == constant.recipeList.count - 1 {
            print("&&&&&&&&&&&&&&&&pass")
            if constant.more_recipes {
                print("Done&&&&&&&&&&&&&&&&pass")
                constant.recipesList_from = constant.recipeList_to + 1
                constant.recipeList_to += 20
                let fromParameter = "&from=\(constant.recipesList_from)"
                let toParameter = "&to=\(constant.recipeList_to)"
                let finalUrl = constant.recipeUrl_searchText + fromParameter + toParameter + constant.filter_text
                updateUI(with: finalUrl)
            }
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

extension RecipeSearch_ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var searchVal = searchBar.text {
            // to remove selected filter
            handleSelected_Button(nil)
            // to remove space before text
            searchVal = searchVal.trimmingCharacters(in: .whitespacesAndNewlines)
            // handle empty search bar
            if searchVal.isEmpty {
                handleAlertMessage(constant.handleEmpty_searchBar)
                constant.recipeList.removeAll()
                updateUI(with: nil)
                searchBar.text = ""
                }
                else{
                    constant.recipeUrl_searchText = constant.recipeURL + searchVal
                    constant.recipesList_from = 0
                    constant.recipeList_to = 10
                    updateUI(with: constant.recipeUrl_searchText)
                }
            }
        }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        do {
            // to Make sure that only english letters & spaces are allowed to be inserted in the search bar
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

extension RecipeSearch_ViewController {
    
    func updateUI(with Url : String?) {
        DispatchQueue.main.async {
            if let url = Url{
                print("*********\(url)")
                NetworkingManager.shared.performRequest(url)
                if let error = self.constant.validateError{
                    self.handleAlertMessage(error)
                    self.constant.validateError = nil
                }else if self.constant.recipes_Count == 0 {
                    self.handleAlertMessage(self.constant.handleNoRecipes)
                }
            }
            self.tableView.reloadData()
        }
    }
    func handleAlertMessage(_ reason:String) {
        let alert = UIAlertController(title: "Warning", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    func handleSelected_Button(_ buttonTag:Int?) {
        switch buttonTag{
        // 0 -> Tag of All filter button
        case 0:
            print("ALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
            All_FilterButton.isSelected = true
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
        // 1 -> Tag of Low Sugar filter button
        case 1:
            print("@@@@@@@@@@@@@@Low Sugar")
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = true
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
        // 2 -> Tag of ketofilter button
        case 2:
            print("@@@@@@@@@@@@@@keto")
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = true
            veganFilter.isSelected = false
        // 3 -> Tag of vegan filter button
        case 3:
            print("@@@@@@@@@@@@@@vegan")
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = true
        default:
            print("@@@@@@@@@@@@@@nil")
            All_FilterButton.isSelected = false
            lowSugarFilter.isSelected = false
            ketoFilter.isSelected = false
            veganFilter.isSelected = false
            
        }
    }
}
