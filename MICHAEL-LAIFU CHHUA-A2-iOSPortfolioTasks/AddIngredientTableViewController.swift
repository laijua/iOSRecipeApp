//
//  AddIngredientTableViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 6/4/21.
//

import UIKit

class AddIngredientTableViewController: UITableViewController, DatabaseListener {
    
    
    var listenerType = ListenerType.ingredient
    weak var databaseController: DatabaseProtocol?
    
    
    weak var saveDelegate: SaveDelegate?
    
    var ingredients = [Ingredient]()
    
    var meal:Meal? // meal we are adding ingredient to

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
        // Do nothing
    }
    
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        // if a change to list of ingredients is made, update local ingredients array to reflect it and reload table to show new updates
        self.ingredients = ingredients
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        if ingredients[indexPath.row].ingredientDescription == nil{
            // if an ingredient has no description, remove the detail accessory button
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            // else add it. the button is already added in story board, but this is done as cells are being reused and without this else block, the buttons wouldn't come back once removed
            cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        }
        cell.textLabel?.text = ingredients[indexPath.row].name

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let ingredient = ingredients[indexPath.row]
        if let ingredientName = ingredient.name {
            // use UIAlertController to ask user to add measurement. If user did not add a measurement and presses done, another UIAlertController is used to alert user that measurement cannot be empty. If measurement is added. alert create/edit table view controller through delegation that an ingredient has been added
            
            let alert = UIAlertController(title: "Add measurement", message: "Enter measurement for \(ingredientName).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "Default action"), style: .default, handler: { [self] _ in
                
                let textField = alert.textFields![0] as UITextField
                if let textFieldText = textField.text {
                    if textFieldText.replacingOccurrences(of: " ", with: "").count <= 0{
                        let alertTwo = UIAlertController(title: "Empty Measurement", message: "You must enter a measurement for \(ingredientName).", preferredStyle: .alert)
                        
                        alertTwo.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss action"), style: .default, handler: { _ in
                        NSLog("Dismissed.")
                        }))
                        
                        self.present(alertTwo, animated: true, completion: nil)
                    }
                    else{
                        // add ingredient measurement to child context
                        if let name = ingredient.name, let meal = meal{
                            let ingredientMeasurement = databaseController?.addIngredientMeasurement(name: name, quantity: textFieldText, meal: meal)
                            
                            if let ingredientMeasurement = ingredientMeasurement{
                                _ = saveDelegate?.addIngredient(ingredientMeasurement)
                            }
                        }
                        
                    
                        
                        
                        navigationController?.popViewController(animated: true)
                    }
                    
                }
            NSLog("Done")
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: { _ in
            NSLog("Cancelled")
            }))
            
    //        https://stackoverflow.com/questions/31922349/how-to-add-textfield-to-uialertcontroller-in-swift
            
            alert.addTextField{ (textField) in
                textField.placeholder = "Measurement"
            }
                
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingredientDetailSegue"{
            let destination = segue.destination as! IngredientDetailViewController
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                destination.ingredient = ingredients[indexPath.row]
                
            }
        }
    }
    

}
