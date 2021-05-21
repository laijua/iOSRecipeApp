//
//  IngredientsData.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 10/4/21.
//

import UIKit

class IngredientsData: NSObject, Decodable {
    // Decodable class for an array of ingredients
    var ingredients: [SingleIngredientData]?
    
    private enum CodingKeys:String, CodingKey{
        case ingredients = "meals"
    }
    
}
