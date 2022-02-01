//
//  RecipeDetailsViewController.swift
//  SoftxpertTask
//
//  Created by Macbook on 31/01/2022.
//

import UIKit
import SafariServices
import SDWebImage
class RecipeDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var recipeWebsiteButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Vars
    var recipe :Recipe?
    var recipeImageLink ,
        recipeWebsiteLink ,
        recipeTitle: String?
    var  recipeIngredients :[String]?
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setData()
        Style.styleRoundedButton(recipeWebsiteButton)
    }
    //MARK: - IBActions

    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func recipeWebsiteButtonPressed(_ sender: Any) {
        let safariVC = SFSafariViewController(url:URL(string: recipeWebsiteLink!)!)
        present(safariVC, animated: true, completion: nil)
    }
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem)
    {
        let recipeURL = URL(string: recipeWebsiteLink!)
        let vc = UIActivityViewController(activityItems: ["open \(recipeTitle!) Website \n \(recipeURL!)"], applicationActivities:nil)
        present(vc, animated: true)
    }
    
    //MARK: - Helper Functions
    
    func setData(){
        if let  title = recipe?.recipe.label {
            recipeTitle = title
        }
        if let  url = recipe?.recipe.url {
            recipeWebsiteLink = url
        }
        if let image = recipe?.recipe.image {
            recipeImageView.sd_setImage(with: URL(string: (image)), placeholderImage: UIImage(named: "noimg"))
        }
        if let  ingredients = recipe?.recipe.ingredientLines {
            recipeIngredients = ingredients
        }
        
    }
}
extension RecipeDetailsViewController :UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IngredientsTableViewCell.self)) as! IngredientsTableViewCell
        ingredientsCell.ingredientLabel.text = recipeIngredients?[indexPath.row]
        return ingredientsCell
    }
}
