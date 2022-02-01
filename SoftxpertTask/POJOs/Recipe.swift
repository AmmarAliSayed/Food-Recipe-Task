//
//  Recipe.swift
//  SoftxpertTask
//
//  Created by Macbook on 27/01/2022.
//

import Foundation

struct RecipeData :Codable{
    let label :String
    let image :String
    let source :String
    let url :String
    let healthLabels :[String]
    let ingredientLines :[String]
}
struct Recipe :Codable {
    let recipe :RecipeData
    
}
struct RecipeModel:Codable {
    let hits : [Recipe]
}
