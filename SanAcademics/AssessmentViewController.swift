//
//  AssessmentViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 23-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class AssessmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formula: UITextView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var alert: UIAlertController?
    var confirmAssessmentAction: UIAlertAction?
    var assessmentType: AssessmentType?
    var assessments = [Assessment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        formula.text = assessmentType!.formula
        getAssessments()
    }
    
    override func viewDidLayoutSubviews() {
        let height = min(self.view.bounds.size.height, self.tableView.contentSize.height)
        tableViewHeightConstraint.constant = height
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAssessments(){
        let context = getContext()
        let predicate = NSPredicate(format: "assessmentType == %@", assessmentType!)
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            assessments = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell", for: indexPath) as! AssessmentTableViewCell
        
        cell.identifier.text = assessments[indexPath.row].identifier
        cell.name.text = assessments[indexPath.row].name
        cell.grade.text = String(describing: assessments[indexPath.row].grade!)
        return cell
    }
    
    @IBAction func onClickAddAssessment(_ sender: Any) {
        alert = UIAlertController(title: "Nueva Evaluación", message: "Agregar evaluación", preferredStyle: .alert)
        alert!.isModalInPopover = true
        
        alert!.addTextField{(textField) in
            textField.placeholder = "Nombre"
            textField.delegate = self
            textField.addTarget(self, action: #selector(AssessmentViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        alert!.addTextField{(textField) in
            textField.placeholder = "Identificador"
            textField.delegate = self
            textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            textField.addTarget(self, action: #selector(AssessmentViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        alert!.addTextField{(textField) in
            textField.placeholder = "Nota"
            textField.keyboardType = UIKeyboardType.numberPad
            textField.delegate = self
            textField.addTarget(self, action: #selector(AssessmentViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        // Cancel Button
        alert!.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(_) in
        }))
        
        // Confirm Button
        confirmAssessmentAction = UIAlertAction(title: "Crear", style: .default, handler: {(_) in
            let nameField = self.alert!.textFields![0]
            let identifierField = self.alert!.textFields![1]
            let gradeField = self.alert!.textFields![2]
            
            let context = getContext()
            let assessment = Assessment(context: context)

            assessment.name = nameField.text
            assessment.identifier = identifierField.text
            assessment.grade = Double(gradeField.text!)! as NSNumber?
            assessment.assessmentType = self.assessmentType
            
            do{
                try context.save()
                
                self.assessments.append(assessment)
                self.tableView.reloadData()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
        })
        
        confirmAssessmentAction!.isEnabled = false
        alert!.addAction(confirmAssessmentAction!)
        
        // Show alert
        self.present(alert!, animated: true, completion: nil)
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        checkAssessmentConfirmButton()
    }
    
    func checkAssessmentConfirmButton(){
        if(alert != nil){
            let nameField = self.alert!.textFields![0]
            let identifierField = self.alert!.textFields![1]
            let gradeField = self.alert!.textFields![2]
            
            if(nameField.hasText && identifierField.hasText && gradeField.hasText){
                confirmAssessmentAction!.isEnabled = true
            }
            else{
                confirmAssessmentAction!.isEnabled = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(alert != nil){
            if(textField == self.alert!.textFields![1]){    // Identifier
                let currentString = textField.text as NSString?
                let newString = currentString?.replacingCharacters(in: range, with: string)
                
                return (newString?.characters.count)! <= 2
            }
            else if(textField == self.alert!.textFields![2]){    // Grade
                let currentString = textField.text as NSString?
                let newString = currentString?.replacingCharacters(in: range, with: string)
                
                return (newString?.characters.count)! <= 6
            }
        }
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
