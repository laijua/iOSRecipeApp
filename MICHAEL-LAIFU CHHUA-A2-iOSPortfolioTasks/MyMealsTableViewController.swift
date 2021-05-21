//
//  MyMealsTableViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class MyMealsTableViewController: UITableViewController, DatabaseListener {
    
    
    var listenerType = ListenerType.meal
    weak var databaseController: DatabaseProtocol?
    
    let SECTION_MEAL = 0
    let SECTION_INFO = 1
    
    let CELL_MEAL = "mealCell"
    let CELL_INFO = "mealSizeCell"
    
    var currentMeals: [Meal] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    // MARK: - viewWillAppear and viewWillDisappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - onChange methods
    
    func onMealChange(change: DatabaseChange, meals: [Meal]) {
        // when change is made to meals in core data, update current meals and reload table view
        currentMeals = meals
        tableView.reloadData()
    }
    
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        // Do nothing
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case SECTION_MEAL:
            return currentMeals.count
        case SECTION_INFO:
            return 1
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MEAL {
            let mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = currentMeals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        if currentMeals.isEmpty { // display instruction to add meal if there is no meal saved
            infoCell.textLabel?.text = "No Saved Meals. Tap + to add some."
        } else {
            infoCell.textLabel?.text = "\(currentMeals.count) stored meal"
        }
        
        return infoCell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // make meal cells editable/deletable
        if indexPath.section == SECTION_MEAL {
            return true
        }
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_MEAL {
            // remove meal from core data, no need to delete meal from currentMeal array as currentMeal will be updated through the onMealChange method. Reloading table view is also done in onMealChange.
            let meal = currentMeals[indexPath.row]
            databaseController?.deleteMeal(meal: meal)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEditMealSegue"{
            let destination = segue.destination as! CreateEditMealTableViewController
            
            // pass in the meal that was selected
            if let index = tableView.indexPathForSelectedRow?.row{
                destination.existingMeal = currentMeals[index]
            }
            
            
        }
    }
    
    
}
