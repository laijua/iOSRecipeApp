//
//  AddMealDelegate.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import Foundation

protocol SaveDelegate: AnyObject {
    // delegate protocol for saving name,instruction and adding ingredient to a meal being editted or created
    func saveName(_ name: String) -> Bool
    func saveInstructions (_ instructions: String) -> Bool
    func addIngredient(_ ingredient: IngredientMeasurement) -> Bool
}
