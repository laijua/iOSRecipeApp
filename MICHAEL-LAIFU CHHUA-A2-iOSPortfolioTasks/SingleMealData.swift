//
//  SingleMealData.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 10/4/21.
//

import UIKit

class SingleMealData: NSObject, Decodable {
    // Decodable class respresenting a meal
    var name: String?
    var instructions: String?
    var ingredients: [IngredientMeasurementData] = []
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(String.self, forKey: .name)
        instructions = try? container.decode(String.self, forKey: .instructions)
        
        
        // for the IngredientMeasurements, append them all to an array. Loop through that array and only append those that aren't nil or have empty name/quantity to the class's ingredients array
        var array =  [IngredientMeasurementData]()
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient1), measurement: try? container.decode(String.self, forKey: .strMeasure1)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient2), measurement: try? container.decode(String.self, forKey: .strMeasure2)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient3), measurement: try? container.decode(String.self, forKey: .strMeasure3)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient4), measurement: try? container.decode(String.self, forKey: .strMeasure4)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient5), measurement: try? container.decode(String.self, forKey: .strMeasure5)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient6), measurement: try? container.decode(String.self, forKey: .strMeasure6)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient7), measurement: try? container.decode(String.self, forKey: .strMeasure7)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient8), measurement: try? container.decode(String.self, forKey: .strMeasure8)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient9), measurement: try? container.decode(String.self, forKey: .strMeasure9)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient10), measurement: try? container.decode(String.self, forKey: .strMeasure10)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient11), measurement: try? container.decode(String.self, forKey: .strMeasure11)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient12), measurement: try? container.decode(String.self, forKey: .strMeasure12)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient13), measurement: try? container.decode(String.self, forKey: .strMeasure13)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient14), measurement: try? container.decode(String.self, forKey: .strMeasure14)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient15), measurement: try? container.decode(String.self, forKey: .strMeasure15)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient16), measurement: try? container.decode(String.self, forKey: .strMeasure16)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient17), measurement: try? container.decode(String.self, forKey: .strMeasure17)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient18), measurement: try? container.decode(String.self, forKey: .strMeasure18)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient19), measurement: try? container.decode(String.self, forKey: .strMeasure19)))
        array.append(IngredientMeasurementData(ingredient: try? container.decode(String.self, forKey: .strIngredient20), measurement: try? container.decode(String.self, forKey: .strMeasure20)))
        
        // loop through array and append those that aren't nil or have empty name/quantity
        for ingredientMeasurement in array{
            if let ingredient = ingredientMeasurement.name, let measurement = ingredientMeasurement.quantity{
                if ingredient.replacingOccurrences(of: " ", with: "").count > 0 || measurement.replacingOccurrences(of: " ", with: "").count > 0 {
                    ingredients.append(ingredientMeasurement)
                }
            }
        }
    }

    private enum CodingKeys: String, CodingKey{
        case name = "strMeal"
        case instructions = "strInstructions"
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20

        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
        
        
        
        
    }
    
    class IngredientMeasurementData: NSObject{
        // class that represents an IngredimentMeasurement
        var name: String?
        var quantity: String?
        
        init(ingredient: String?, measurement: String?) {
            self.name = ingredient
            self.quantity = measurement
        }
    }
}
