//
//  CreateEditMealTableViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class CreateEditMealTableViewController: UITableViewController, SaveDelegate {
    
    weak var databaseController: DatabaseProtocol?
    
    var ingredients: [IngredientMeasurement] = []
    
    var editOfMeal: Meal?
    
    var existingMeal: Meal?
    
    let SECTION_MEAL_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENTS = 2
    let SECTION_ADD_INGREDIENT = 3
    
    
    let CELL_MEAL_NAME = "mealNameCell"
    let CELL_INSTRUCTIONS = "instructionsCell"
    let CELL_INGREDIENTS = "ingredientsCell"
    let CELL_ADD_INGREDIENT = "addIngredientCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // if a meal was passed through, make a copy of it in the child context, else create a new meal in the child context
        if let meal = existingMeal{
            title = meal.name // change title of navigation to meal's name
            editOfMeal = databaseController?.copyMeal(meal: meal)
        }
        else{
            // create a new meal with empty name, instruction and ingredients
            editOfMeal = databaseController?.addMeal(name: nil, instructions: nil)
        }
        
        ingredients = editOfMeal?.ingredients?.allObjects as! [IngredientMeasurement]
    }
    
    
    // MARK: - viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // if the back button is pressed, roll back the child context
        if self.isMovingFromParent {
            databaseController?.rollbackChild()
        }
    }
    
    
    // MARK: - SaveDelegate
    func saveName(_ name: String) -> Bool {
        // assign the passed in name to the meal's name and reload the name section
        if let editOfMeal = editOfMeal{
            editOfMeal.name = name
        }
        tableView.reloadSections([SECTION_MEAL_NAME], with: .automatic)
        return true
    }
    
    func saveInstructions(_ instructions: String) -> Bool {
        // assignment the passed in instruction to the meal's instruction and reload the instructions section
        if let editOfMeal = editOfMeal{
            editOfMeal.instructions = instructions
        }
        tableView.reloadSections([SECTION_INSTRUCTIONS], with: .automatic)
        return true
    }
    
    func addIngredient(_ ingredient: IngredientMeasurement) -> Bool {
        // add in the passed ingredientMeasurement to the meal and reload the ingredient section
        if let editOfMeal = editOfMeal{
            editOfMeal.addToIngredients(ingredient)
            ingredients.append(ingredient) // add to array as well as array is the data that is controlling what the table view displays for ingredient
        }
        tableView.reloadSections([SECTION_INGREDIENTS], with: .automatic)
        return true
    }
    
    
    // MARK: - Save
    @IBAction func saveButton(_ sender: Any) {
        
        if let name = editOfMeal?.name, let instructions = editOfMeal?.instructions{
            // For name and instruction, remove and blanks and check that the string without blanks' length is greater than 0 and for ingredients, check that there is at least one ingredient before saving
            if name.replacingOccurrences(of: " ", with: "").count > 0 && instructions.replacingOccurrences(of: " ", with: "").count > 0 && ingredients.count > 0{
                
                databaseController?.saveChild() // save to parent context
                navigationController?.popToRootViewController(animated: true)

                return
            }
            
        }
        // if code enters here, it means one or more of name, instruction or ingredient was empty. create an alert controller to alert user
        let alert = UIAlertController(title: "One or more fields is empty.", message: "One or more fields is empty.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss action"), style: .default, handler: { _ in
            NSLog("Dismissed.")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_MEAL_NAME:
            return 1
        case SECTION_INSTRUCTIONS:
            return 1
        case SECTION_INGREDIENTS:
            return ingredients.count
        case SECTION_ADD_INGREDIENT:
            return 1
        default:
            return 0
        }
    }
    
    // Create a standard header that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        // create headers for each section
        switch section {
        case SECTION_MEAL_NAME:
            return "MEAL NAME"
        case SECTION_INSTRUCTIONS:
            return "INSTRUCTIONS"
        case SECTION_INGREDIENTS:
            return "INGREDIENTS"
        default:
            return " "
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case SECTION_MEAL_NAME:
            let mealNameCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_NAME, for: indexPath)
            
            if let editOfmealName = editOfMeal?.name{
                if editOfmealName.count > 0{
                    mealNameCell.textLabel?.text = editOfmealName
                    mealNameCell.textLabel?.textColor = UIColor(named: "textColor") // set text from grey to custom color(cause need to support dark mode). text colour was left as grey by default in the storyboard
                }
                
            }
            
            return mealNameCell
            
        case SECTION_INSTRUCTIONS:
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: CELL_INSTRUCTIONS, for: indexPath)
            
            if let editOfmealInstructions = editOfMeal?.instructions{
                if editOfmealInstructions.count > 0{
                    instructionCell.textLabel?.text = editOfmealInstructions
                    instructionCell.textLabel?.textColor = UIColor(named: "textColor")
                }
            }
            return instructionCell
            
        case SECTION_INGREDIENTS:
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENTS, for: indexPath) as!
                IngredientsTableViewCell
            let ingredient = ingredients[indexPath.row]
            ingredientsCell.ingredientLabel.text = ingredient.name
            ingredientsCell.measurementLabel.text = ingredient.quantity
            return ingredientsCell
            
        default:
            let addIngredientCell = tableView.dequeueReusableCell(withIdentifier: CELL_ADD_INGREDIENT, for: indexPath)
            addIngredientCell.textLabel?.text = "Add Ingredient"
            return addIngredientCell
            
            
        }
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // make on the ingredient cells editable/deletable
        if indexPath.section == SECTION_INGREDIENTS {
            return true
        }
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENTS {
            // delete ingredient from child meal object, from the child context and array then reload ingredient section
            let ingredient = ingredients[indexPath.row]
            editOfMeal?.removeFromIngredients(ingredient)
            databaseController?.deleteIngredientMeasurement(ingredientMeasurement: ingredient)
            ingredients.remove(at: indexPath.row)
            tableView.reloadSections([SECTION_INGREDIENTS], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // make the ingredient cells not selectable 
        if (indexPath.section == SECTION_INGREDIENTS){
            return nil
        }
        return indexPath
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNameSegue"{
            let destination = segue.destination as! EditNameViewController
            destination.meal = editOfMeal
            destination.saveDelegate = self
        }
        else if segue.identifier == "editInstructionsSegue"{
            let destination = segue.destination as! EditInstructionsViewController
            destination.meal = editOfMeal
            destination.saveDelegate = self
        }
        else if  segue.identifier == "addIngredientSegue"{
            let destination = segue.destination as! AddIngredientTableViewController
            destination.saveDelegate = self
            destination.meal  = editOfMeal
        }
    }
}
