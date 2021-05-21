//
//  EditInstructionsViewController.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 3/4/21.
//

import UIKit

class EditInstructionsViewController: UIViewController {
    
    var meal:Meal? // the meal we are editting the instruction of
    weak var saveDelegate: SaveDelegate?
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint! // bottom constraint of the text view. Value is changed for when keyboard appears
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsTextView.text = meal?.instructions // populate text view with instruction if any.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        // check if instruction is not empty and call delegate to let other view controller know to update instruction
        if let instructions = instructionsTextView.text, instructions.replacingOccurrences(of: " ", with: "").count > 0{
            _ = saveDelegate?.saveInstructions(instructions)
            navigationController?.popViewController(animated: true)
        }
        else{
            // if instruction is empty, alert user with UIAlertController
            let alert = UIAlertController(title: "Instructions cannot be empty.", message: "Instructions cannot be empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss action"), style: .default, handler: { _ in
                NSLog("Dismissed.")
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Handling keyboard
    // code taken from lectures
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo, let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            textViewBottomConstraint.constant = keyboardSize.cgRectValue.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint.constant = 0
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
