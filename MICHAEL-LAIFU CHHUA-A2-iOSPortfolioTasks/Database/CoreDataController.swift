//
//  CoreDataController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 8/4/21.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    var allMealFetchedResultsController: NSFetchedResultsController<Meal>?
    var allIngredientFetchedResultsController: NSFetchedResultsController<Ingredient>?
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // the child context
    
    
    override init() {
        
        persistentContainer = NSPersistentContainer(name: "Assignment2-DataModel")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        childContext.parent = persistentContainer.viewContext // assign parent of child context
        
        super.init()
        // if there is no ingredient, query web service for ingredients
        if fetchAllIngredients().count == 0 {
            createDefaultIngredients()
        }
    }
    
    func saveChild(){
        // method for saving child context to parent
        if childContext.hasChanges {
            do {
                try childContext.save()
            } catch {
                fatalError("Failed to save changes to Parent Context with error: \(error)")
            }
        }
    }
    
    func rollbackChild(){
        // method for rolling back child context
        childContext.rollback()
    }
    
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    // MARK: - Ingredient
    func addIngredient(name: String?, ingredientDescription: String?) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName:
                                                                "Ingredient", into: childContext) as! Ingredient
        ingredient.name = name
        ingredient.ingredientDescription = ingredientDescription
        return ingredient
    }
    
    func deleteIngredient(ingredient: Ingredient) {
        persistentContainer.viewContext.delete(ingredient)
    }
    
    func fetchAllIngredients() -> [Ingredient] {
        if allIngredientFetchedResultsController == nil {
            let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            
            // Initialise Fetched Results Controller
            allIngredientFetchedResultsController =
                NSFetchedResultsController<Ingredient>(fetchRequest: request,
                                                      managedObjectContext: persistentContainer.viewContext,
                                                      sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allIngredientFetchedResultsController?.delegate = self
            
            do {
                try allIngredientFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
            
        }
        if let ingredients = allIngredientFetchedResultsController?.fetchedObjects {
            return ingredients
        }
        return [Ingredient]()
    }
    
    // MARK: - Meal
    
    func addMeal(name: String?, instructions: String?) -> Meal {
        // reason paramters can be nil is because we could be creating a completely new meal that does no have a name or instruction yet, a new empty Meal in the child context
        let meal = NSEntityDescription.insertNewObject(forEntityName:
                                                        "Meal", into: childContext) as! Meal
        meal.name = name
        meal.instructions = instructions
        return meal
    }
    
    func deleteMeal(meal:Meal) {
        persistentContainer.viewContext.delete(meal)
    }
    
    func fetchAllMeals() -> [Meal] {
        
        if allMealFetchedResultsController == nil {
            // Do something
            let request: NSFetchRequest<Meal> = Meal.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allMealFetchedResultsController =
                NSFetchedResultsController<Meal>(fetchRequest: request,
                                                 managedObjectContext: persistentContainer.viewContext,
                                                 sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allMealFetchedResultsController?.delegate = self
            
            do {
                try allMealFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        if let meals = allMealFetchedResultsController?.fetchedObjects {
            return meals
        }
        return [Meal]()
        
    }
    
    func copyMeal(meal: Meal) -> Meal {
        // method for making a copy of an existing meal in child context
        return childContext.object(with: meal.objectID) as! Meal
    }
    
    // MARK: - IngredientMeasurement
    
    func addIngredientMeasurement(name: String, quantity: String, meal: Meal) -> IngredientMeasurement{
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName:
                                                                            "IngredientMeasurement", into: childContext) as! IngredientMeasurement
        ingredientMeasurement.name = name
        ingredientMeasurement.quantity = quantity
        ingredientMeasurement.meals = meal
        return ingredientMeasurement
    }
    func deleteIngredientMeasurement(ingredientMeasurement:IngredientMeasurement){
        childContext.delete(ingredientMeasurement)
    }
    
    
    // MARK: - Fetched Results Controller Protocol methods
    func controllerDidChangeContent(_ controller:
                                        NSFetchedResultsController<NSFetchRequestResult>) {
        
        if controller == allMealFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .meal {
                    listener.onMealChange(change: .update,
                                          meals: fetchAllMeals())
                }
            }
        }
        else if controller == allIngredientFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .ingredient {
                    listener.onIngredientChange(change: .update,
                                                ingredients:  fetchAllIngredients())
                }
            }
        }
    }
    
    

    
    
    // MARK: - Listener
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .ingredient{
            listener.onIngredientChange(change: .update, ingredients: fetchAllIngredients())
        }
        else if listener.listenerType == .meal{
            listener.onMealChange(change: .update, meals: fetchAllMeals())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func createDefaultIngredients() {
        // query web service for ingredients and add to core data
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list") else{return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error)
            }
            else if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let ingredientsData = try decoder.decode(IngredientsData.self, from: data)
                    if let ingredients = ingredientsData.ingredients{
                        for ingredient in ingredients{
                            let _ = self.addIngredient(name: ingredient.ingredient, ingredientDescription: ingredient.ingredientDescription)
                        }
                        self.saveChild()
                    }
                    
                 }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    
    
    
}
