//
//  IngredientDetailViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class IngredientDetailViewController: UIViewController {
    
    @IBOutlet weak var ingredientDetailTextView: UITextView!
    
    var ingredient: Ingredient? // the ingredient passed through to show detail of 

    override func viewDidLoad() {
        // retrieve ingredient description and display through text view
        super.viewDidLoad()
        if let ingredient = ingredient{
            ingredientDetailTextView.text = ingredient.ingredientDescription
            title = ingredient.name // change title of navigation to ingredient's name
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
