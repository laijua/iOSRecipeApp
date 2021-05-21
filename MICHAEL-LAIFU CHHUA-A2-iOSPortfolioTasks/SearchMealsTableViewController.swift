//
//  SearchMealsTableViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class SearchMealsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchedPerformed = false // used to show info cell when search has performed, handled in numberOfRowsInSection
    
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    
    
    weak var databaseController: DatabaseProtocol?
    
    
    let SECTION_MEAL = 0
    let SECTION_INFO = 1
    
    let CELL_MEAL = "mealCell"
    let CELL_INFO = "infoCell"
    
    var indicator = UIActivityIndicatorView()
    var newMeals = [SingleMealData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
    }
    
    
    
    func requestMealsNamed(_ mealName: String) {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "www.themealdb.com"
        searchURLComponents.path = "/api/json/v1/1/search.php"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "s", value: mealName)
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let mealsData = try decoder.decode(MealsData.self, from: data!)
                if let meals = mealsData.meals {
                    self.newMeals.append(contentsOf: meals)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    if meals.count == self.MAX_ITEMS_PER_REQUEST,
                       self.currentRequestIndex + 1 < self.MAX_REQUESTS {
                        self.currentRequestIndex += 1
                        self.requestMealsNamed(mealName)
                    }
                }
            } catch let err {
                print(err)
            }
            
            
        }
        task.resume()
        

        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchedPerformed = true // set to true so info cell is shown
        
        newMeals.removeAll()
        tableView.reloadData()
        guard let searchText = searchBar.text, searchText.count > 0 else {return}
        
        indicator.startAnimating()
        URLSession.shared.invalidateAndCancel()
        currentRequestIndex = 0
        requestMealsNamed(searchText)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_MEAL:
            return newMeals.count
        case SECTION_INFO:
            if searchedPerformed{ // if search is performed, show info cell, else don't
                return 1
            }
            return 0
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_MEAL {
            let mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = newMeals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        infoCell.textLabel?.text = "Not what you were looking for? \nTap to add a new meal."
       
        return infoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                                IndexPath) {
        if indexPath.section == SECTION_MEAL{
            // when a searched cell is selected, create a new meal using the searched meal's name, instruction and ingredient. For adding ingredients, it is done through looping through the searched meal's ingredients.
            
            let meal = newMeals[indexPath.row]
            let newMeal = databaseController?.addMeal(name: meal.name, instructions: meal.instructions)
            for ingredient in meal.ingredients{
                if let name = ingredient.name, let quantity = ingredient.quantity, let newMeal = newMeal{
                    let newIngredient = databaseController?.addIngredientMeasurement(name: name, quantity: quantity, meal: newMeal)
                    if let newIngredient = newIngredient{
                        newMeal.addToIngredients(newIngredient)
                    }
                }
            }
            databaseController?.saveChild()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
 
     }
     
    
}

