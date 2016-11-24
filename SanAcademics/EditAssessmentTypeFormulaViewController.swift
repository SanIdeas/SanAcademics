//
//  EditAssessmentTypeFormulaViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 23-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class EditAssessmentTypeFormulaViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var formula: UITextView!
    
    var numberAlert: UIAlertController?
    var confirmAddNumberAction: UIAlertAction?
    var assessmentType: AssessmentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        formula.delegate = self
        formula.text = assessmentType!.formula
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView == formula){
            return range.length == 1 && text.characters.count == 0
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AssessmentIdentifierSegue"){
            let navigationController = segue.destination as! UINavigationController
            let identifierController = navigationController.viewControllers[0] as! IdentifierAssessmentTableViewController
            
            identifierController.assessmentType = assessmentType
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(numberAlert != nil){
            if(textField == self.numberAlert!.textFields![0]){    // Number
                let currentString = textField.text as NSString?
                let newString = currentString?.replacingCharacters(in: range, with: string)
                let times = newString?.components(separatedBy: ".")
                
                let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
                return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil && times!.count <= 2
            }
        }
        
        return true
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        checkAddNumberConfirmButton()
    }
    
    func checkAddNumberConfirmButton(){
        if(numberAlert != nil){
            let numberField = self.numberAlert!.textFields![0]
            let text = numberField.text
            
            if(numberField.hasText && text![text!.index(before: text!.endIndex)] != "." && text![text!.startIndex] != "."){
                confirmAddNumberAction!.isEnabled = true
            }
            else{
                confirmAddNumberAction!.isEnabled = false
            }
        }
    }
    
    @IBAction func onCancelAddAssessmentId(segue: UIStoryboardSegue){
    }
    
    @IBAction func onAddAssessmentId(segue: UIStoryboardSegue){
        let controller = segue.source as! IdentifierAssessmentTableViewController
        formula.replace(formula.selectedTextRange!, withText: " $\(controller.selectedId!) ")
    }
    
    @IBAction func onClickAddNumber(_ sender: Any) {
        numberAlert = UIAlertController(title: "Nuevo Número", message: "Agregar número", preferredStyle: .alert)
        numberAlert!.isModalInPopover = true
        
        numberAlert!.addTextField{(textField) in
            textField.placeholder = "Número"
            textField.keyboardType = UIKeyboardType.decimalPad
            textField.delegate = self
            textField.addTarget(self, action: #selector(EditAssessmentTypeFormulaViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        // Cancel Button
        numberAlert!.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(_) in
        }))
        
        // Confirm Button
        confirmAddNumberAction = UIAlertAction(title: "Agregar", style: .default, handler: {(_) in
            let numberField = self.numberAlert!.textFields![0]
            self.formula.replace(self.formula.selectedTextRange!, withText: " \(numberField.text!) ")
        })
        
        confirmAddNumberAction!.isEnabled = false
        numberAlert!.addAction(confirmAddNumberAction!)
        
        // Show alert
        self.present(numberAlert!, animated: true, completion: nil)
    }
    
    @IBAction func onCancelAddAssessmentOperator(segue: UIStoryboardSegue){
    }
    
    @IBAction func onAddAssessmentOperator(segue: UIStoryboardSegue){
        let controller = segue.source as! OperatorAssessmentTableViewController
        formula.replace(formula.selectedTextRange!, withText: " \(controller.selectedOperator!) ")
    }
    
    @IBAction func onCancelAddAssessmentFunction(segue: UIStoryboardSegue){
    }
    
    @IBAction func onAddAssessmentFunction(segue: UIStoryboardSegue){
        let controller = segue.source as! FunctionAssessmentTableViewController
        formula.replace(formula.selectedTextRange!, withText: " \(controller.selectedFunction!) ")
    }
    
    @IBAction func onAddBlock(_ sender: Any) {
        formula.replace(formula.selectedTextRange!, withText: " ( ) ")
    }

}
