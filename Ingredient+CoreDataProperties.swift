//
//  Ingredient+CoreDataProperties.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 8/4/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredientDescription: String?

}

extension Ingredient : Identifiable {

}
