//
//  RecipeSearchViewModel.swift
//  SoftxpertTask
//
//  Created by Macbook on 29/01/2022.
//

import Foundation
class RecipeSearchViewModel: NSObject {
    //property from model
    var  networkService : NetworkService!
    let defaults = UserDefaults.standard
    var tempArray :[String] = []
    //property to get the data from api when success
    var recipeData : [Recipe]!{
        didSet{
            //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindRecipeToSearchView()
        }
    }
    var recentSearchesArray:[String]!{
        didSet{
            self.bindSuggestionToHistorySearchTableView()
        }
    }
    //property when the Alert happened
    var showAlertMessage : String!{
        didSet{
            //we add listener her so when we set the showAlertMessage property we will call
            //bindViewModelAlertMessageToView() function type
            self.bindViewModelAlertMessageToView()
        }
    }
    //functions type
    var bindViewModelAlertMessageToView : (()->()) = {}
    var bindRecipeToSearchView : (()->()) = {}
    var bindSuggestionToHistorySearchTableView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.networkService = NetworkService()
    }
    
    func addRestrictionOnSearchBar(searchBarText:String)->Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
            if regex.firstMatch(in: searchBarText, options: [], range: NSMakeRange(0, searchBarText.count)) != nil
            {
               // print("only english letters and spaces are allowed")
               // self.showAlertTitle = "Invalid"
                self.showAlertMessage = "only english letters and spaces are allowed"
                return true
            }
            else
            {
                return false
            }
        }
        catch {
            print("ERROR")
        }
        return false
    }
    func fetchRecipesDataFromApi(of searchText:String ,health:String?){
        shouldStartLoading()
        networkService.getRecipesFromAPI(of: searchText, health: health)
        {(recipeArray,error) in
            if let error :Error = error{
                let message = error.localizedDescription
                if error.asAFError?.responseCode == -1 {
                   print("No Internet")
                }else{
                    print(message) 
                }
            }else{
                self.recipeData = recipeArray
            }
            self.shouldEndLoading()
        }
    }
    func addNewRecentSuggestion(suggestion:String){
        tempArray = defaults.stringArray(forKey: "recentSearchesArray") ?? []
        self.tempArray = tempArray.filter { $0 != suggestion }
        tempArray.append(suggestion)
        defaults.set(tempArray, forKey: "recentSearchesArray")
    }
    func getRecentSuggestions(){
        recentSearchesArray = defaults.stringArray(forKey: "recentSearchesArray")
    }
}
