//
//  HistorySearchTableViewController.swift
//  SoftxpertTask
//
//  Created by Macbook on 27/01/2022.
//

import UIKit

class HistorySearchTableViewController: UITableViewController {

    //MARK: - Vars
    var delegate : SearchHistoryDelegate?
    let recipeSearchViewModel = RecipeSearchViewModel()
    var suggestionsArray :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeSearchViewModel.bindSuggestionToHistorySearchTableView = {
            self.updateView()
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        recipeSearchViewModel.getRecentSuggestions()
        
    }
    //MARK: - helper functions
    func updateView(){
        if let suggestions = recipeSearchViewModel.recentSearchesArray {
            suggestionsArray = suggestions
           // display only last 10 elements in array
            suggestionsArray = Array(suggestionsArray.suffix(10))
            //reverse array
            suggestionsArray.reverse()
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return suggestionsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let historySearchCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistorySearchTableViewCell.self), for: indexPath) as! HistorySearchTableViewCell
        historySearchCell.recentSearchLabel.text = suggestionsArray[indexPath.row]
    return historySearchCell
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
     //   print(recentSearchesArray[indexPath.row])
        delegate?.getSearchResultFromHistory(selectedSearchHistory:suggestionsArray[indexPath.row] )
        dismiss(animated: true, completion: nil)
    }
}

//show HistorySearchTableView when user click on search bar
extension HistorySearchTableViewController :UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        //show recent research when user click on search bar
        searchController.searchResultsController?.view.isHidden = false
    }
}
