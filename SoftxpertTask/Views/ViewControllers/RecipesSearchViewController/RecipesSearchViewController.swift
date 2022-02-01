//
//  RecipesSearchViewController.swift
//  SoftxpertTask
//
//  Created by Macbook on 25/01/2022.
//

import UIKit
import SDWebImage

class RecipesSearchViewController: UIViewController{
    //MARK: - IBOutlets
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var noRecipeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - Vars
    let recipeSearchViewModel = RecipeSearchViewModel()
    var searchController :UISearchController!
    var recipeArray = [Recipe]()
    //store selected search in variable to send it when user select filter
    var selectedSearch :String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeSearchViewModel.bindViewModelAlertMessageToView = {
            self.showAlert(message: self.recipeSearchViewModel.showAlertMessage)
        }
        recipeSearchViewModel.bindRecipeToSearchView = {
            self.updateView()
        }
        recipeSearchViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIdicator()
        }
        
        recipeSearchViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIdicator()
        }
        recipeTableView.isHidden = true
        noRecipeLabel.isHidden = false

        collectionView.delegate = self
        collectionView.dataSource = self
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        showSearchController()
    }
    //MARK: - helper functions
    func updateView(){
        recipeArray = recipeSearchViewModel.recipeData
        self.recipeTableView.reloadData()
    }
    func showSearchController() {
        //set history tableview to searchcontroller as search result
        let historySearchTableView = storyboard!.instantiateViewController(withIdentifier: String(describing: HistorySearchTableViewController.self)) as! HistorySearchTableViewController
       searchController = UISearchController(searchResultsController: historySearchTableView )
        //delegate
        historySearchTableView.delegate = self
        searchController.searchResultsUpdater = historySearchTableView as? UISearchResultsUpdating
        //change cancel button color
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = .black
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search..."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    func showAlert(message:String) {
        let alert = MyAlertViewController(title: "Invalid", message: message, imageName: "warning_icon")
        alert.addAction(title: "OK", style: .default)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)

    }
    //MARK: - Activity Indicator
    private func showLoadingIdicator() {
        self.showIndicator(withTitle: "", and: "")
    }
    private func hideLoadingIdicator() {
        self.hideIndicator()
    }
}
extension RecipesSearchViewController : UICollectionViewDelegate ,UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCollectionViewCell.self), for: indexPath) as! FilterCollectionViewCell
   
       let title = K.filterArray[indexPath.row]
        cell.setupCell(text: title)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let selectedFilter = K.filterArray[indexPath.row]
        guard selectedSearch != nil else {
            print("selected search is nil")
            return
        }
        switch selectedFilter {
        case "All":
            print("filter : all")
          recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearch, health: nil)
        case "Low Sugar":
           print("filter: low sugar")
            recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearch, health: "low-sugar")
        case "Keto":
           print("filter: keto")
           recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearch, health: "keto-friendly")
        case "Vegan":
            recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearch, health: "vegan")
           print("filter: vegan")
        default:
            print("no filter")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = nil
    }
}
//MARK:- search bar delegate
extension RecipesSearchViewController : UISearchBarDelegate{
    //when user clicked search button in keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // print("search..........")
        //set regex to allow only english letters and spaces
        if recipeSearchViewModel.addRestrictionOnSearchBar(searchBarText: searchBar.text!){
            //empty searchBar after show the alert
            searchBar.text = ""
            return
        }
        //check empty spaces
        guard searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty == false
        else {
          //  print("empty ....")
            self.showAlert(message: "empty spaces are not allowed")
            return
        }
        selectedSearch = searchBar.text!
        //save New Recent Suggestion to userdefaults
        recipeSearchViewModel.addNewRecentSuggestion(suggestion: selectedSearch)
        //hide noRecipeLabel
        noRecipeLabel.isHidden = true
        //show table view
        recipeTableView.isHidden = false
        //get recipe data from api
        recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearch, health: nil)
        dismiss(animated: true, completion: nil)
    }
    // called when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true
        {
            print("no search")
            //RecipeSearchViewModel
        }
    }
}

//MARK: - SearchHistoryDelegate
extension RecipesSearchViewController : SearchHistoryDelegate {
    func getSearchResultFromHistory(selectedSearchHistory: String) {
        selectedSearch = selectedSearchHistory
        searchController.searchBar.text = selectedSearchHistory
        noRecipeLabel.isHidden = true
        //hide noRecipeLabel
        noRecipeLabel.isHidden = true
        //show table view
        recipeTableView.isHidden = false
        recipeSearchViewModel.fetchRecipesDataFromApi(of: selectedSearchHistory, health: nil)
      //  print(selectedSearchHistory)
    }
}
extension RecipesSearchViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeTableViewCell.self)) as! RecipeTableViewCell
        let recipe = recipeArray[indexPath.row].recipe
        recipeCell.recipeTitleLabel.text = recipe.label
        recipeCell.recipeSourceLabel.text = recipe.source
        recipeCell.recipeHealthLabel.text = ""
        for health in recipe.healthLabels{
            //to remove comma from last element
            if health == recipe.healthLabels.last
            {
                recipeCell.recipeHealthLabel.text! += "\(health)"
            }
            else {

                recipeCell.recipeHealthLabel.text! += "\(health), "
            }

        }
        
         let image = recipe.image
        recipeCell.recipeImage.sd_setImage(with: URL(string: (image)), placeholderImage: UIImage(named: "noimg"))
        
        return recipeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      // print("mmmmmmmmmmm")
        tableView.deselectRow(at: indexPath, animated: true)
        let recipeDetailsViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RecipeDetailsViewController.self)) as! RecipeDetailsViewController
        recipeDetailsViewController.modalPresentationStyle = .fullScreen
        recipeDetailsViewController.recipe = recipeArray[indexPath.row]
       // navigate to details screen
        self.present(recipeDetailsViewController, animated: true, completion: nil)
    }
    
}
