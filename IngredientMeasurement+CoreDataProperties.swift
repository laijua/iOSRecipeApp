//
//  IngredientMeasurement+CoreDataProperties.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 8/4/21.
//
//

import Foundation
import CoreData


extension IngredientMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientMeasurement> {
        return NSFetchRequest<IngredientMeasurement>(entityName: "IngredientMeasurement")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var meals: Meal?

}

extension IngredientMeasurement : Identifiable {

}
