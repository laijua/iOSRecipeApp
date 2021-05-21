//
//  DatabaseProtocol.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 8/4/21.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case meal
    case ingredient
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onMealChange(change: DatabaseChange, meals: [Meal])
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient])
}

protocol DatabaseProtocol: AnyObject {
    
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addIngredient(name: String?, ingredientDescription: String?) -> Ingredient
    func deleteIngredient(ingredient: Ingredient)
    
    func addMeal(name:String?, instructions:String?) -> Meal // create a new meal in child context
    func deleteMeal(meal:Meal)
    func copyMeal(meal:Meal) -> Meal // make a copy of existing meal in child context
    
    
    func addIngredientMeasurement(name: String, quantity: String, meal: Meal) -> IngredientMeasurement
    func deleteIngredientMeasurement(ingredientMeasurement:IngredientMeasurement)
    
    func saveChild() // save child context to parent
    func rollbackChild() // roll back child context to previous state, in this case when the child context was an exact copy of parent
    
    
}
