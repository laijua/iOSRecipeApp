//
//  SingleIngredientData.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 10/4/21.
//

import UIKit

class SingleIngredientData: NSObject, Decodable {
    // Decodable class for Ingredient
    
    var ingredient: String?
    var ingredientDescription: String?
    
    private enum CodingKeys: String, CodingKey{
        case ingredient = "strIngredient"
        case ingredientDescription = "strDescription"
    }
    
}
