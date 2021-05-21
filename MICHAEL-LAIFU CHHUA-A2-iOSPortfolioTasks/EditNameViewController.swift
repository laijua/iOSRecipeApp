//
//  EditNameViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class EditNameViewController: UIViewController {
    var meal:Meal? // the meal we are editting the name of
    weak var saveDelegate: SaveDelegate?

    @IBOutlet weak var editNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editNameLabel.text = meal?.name // populate label text with name if any
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // check if name is not empty and call delegate to let other view controller know to update name through delegation
        if let name = editNameLabel.text, name.replacingOccurrences(of: " ", with: "").count > 0{
            _ = saveDelegate?.saveName(name)
            navigationController?.popViewController(animated: true)
        }
        else{
            // if name is empty, alert user with UIAlertController
            let alert = UIAlertController(title: "Name cannot be empty.", message: "Name cannot be empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss action"), style: .default, handler: { _ in
            NSLog("Dismissed.")
            }))
            
            self.present(alert, animated: true, completion: nil)
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
