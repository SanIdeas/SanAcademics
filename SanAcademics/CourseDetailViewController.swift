//
//  CourseDetailViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 22-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var formula: UITextView!
    
    var coursesTableViewController: CoursesTableViewController?
    var alert: UIAlertController?
    var confirmAssessmentTypeAction: UIAlertAction?
    var course: Course?
    var assessmentTypes = [AssessmentType]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        updateFormula(course!.formula)
        getAssessmentTypes()
    }
    
    override func viewDidLayoutSubviews() {
        let height = min(self.view.bounds.size.height, self.tableView.contentSize.height, 267)
        tableViewHeightConstraint.constant = max(height, 44)
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAssessmentTypes(){
        let context = getContext()
        let predicate = NSPredicate(format: "course == %@", course!)
        let fetchRequest: NSFetchRequest<AssessmentType> = AssessmentType.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            assessmentTypes = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(assessmentTypes.count <= 0){
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            emptyLabel.text = "No hay tipos de evaluaciones agregadas"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
        }
        else{
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        return assessmentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTypeCell", for: indexPath) as! AssessmentTypeTableViewCell
        
        cell.identifier.text = assessmentTypes[indexPath.row].identifier
        cell.name.text = assessmentTypes[indexPath.row].name
        cell.grade.text = String(format: "%.2f", assessmentTypes[indexPath.row].average)
        return cell
    }

    @IBAction func onClickAddAssessmentType(_ sender: Any) {
        alert = UIAlertController(title: "Nuevo Tipo de Evaluación", message: "Agregar tipo de evaluación", preferredStyle: .alert)
        alert!.isModalInPopover = true
        
        alert!.addTextField{(textField) in
            textField.placeholder = "Nombre"
            textField.delegate = self
            textField.addTarget(self, action: #selector(CourseDetailViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        alert!.addTextField{(textField) in
            textField.placeholder = "Identificador"
            textField.delegate = self
            textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            textField.addTarget(self, action: #selector(CourseDetailViewController.editingChanged(_:)), for: .editingChanged)
        }
        
        // Cancel Button
        alert!.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(_) in
        }))
        
        // Confirm Button
        confirmAssessmentTypeAction = UIAlertAction(title: "Crear", style: .default, handler: {(_) in
            let nameField = self.alert!.textFields![0]
            let identifierField = self.alert!.textFields![1]
            
            let context = getContext()
            let assessmentType = AssessmentType(context: context)
            
            assessmentType.name = nameField.text
            assessmentType.identifier = identifierField.text
            assessmentType.course = self.course
            
            do{
                try context.save()
                
                self.assessmentTypes.append(assessmentType)
                self.tableView.reloadData()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
        })
        
        confirmAssessmentTypeAction!.isEnabled = false
        alert!.addAction(confirmAssessmentTypeAction!)
        
        // Show alert
        self.present(alert!, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(alert != nil){
            if(textField == self.alert!.textFields![1]){    // Identifier
                let currentString = textField.text as NSString?
                let newString = currentString?.replacingCharacters(in: range, with: string)
                
                return (newString?.characters.count)! <= 2
            }
        }
        
        return true
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        checkAssessmentTypeConfirmButton()
    }
    
    func checkAssessmentTypeConfirmButton(){
        if(alert != nil){
            let nameField = self.alert!.textFields![0]
            let identifierField = self.alert!.textFields![1]
            
            if(nameField.hasText && identifierField.hasText){
                confirmAssessmentTypeAction!.isEnabled = true
            }
            else{
                confirmAssessmentTypeAction!.isEnabled = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AssessmentSegue"){
            let assessmentController = segue.destination as! AssessmentViewController
            let button = sender as! UIButton
            let cell = button.superview!.superview as! AssessmentTypeTableViewCell
            let index = tableView.indexPath(for: cell)!.row
            
            assessmentController.assessmentType = assessmentTypes[index]
            assessmentController.navigationItem.title = assessmentTypes[index].name
            assessmentController.assessmentTypesViewController = self
        }
        else if(segue.identifier == "EditCourseFormulaSegue"){
            let navigationController = segue.destination as! UINavigationController
            let formulaController = navigationController.viewControllers[0] as! EditCourseFormulaViewController
            
            formulaController.course = course
        }
    }
    
    @IBAction func onDeleteAssessmentType(segue: UIStoryboardSegue) {
        let assessmentController = segue.source as! AssessmentViewController
        
        // Delete assessment
        let context = getContext()
        let assessmentType = assessmentController.assessmentType!
        let index = assessmentTypes.index(of: assessmentType)!
        
        context.delete(assessmentType)
        do{
            try context.save()
            
            assessmentTypes.remove(at: index)
            self.tableView.reloadData()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.localizedDescription)")
        }
    }
    
    func updateFormula(_ newFormula: String?){
        if(newFormula != nil && !newFormula!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            formula.text = newFormula
        }
        else{
            formula.text = "No hay una fórmula asignada"
        }
    }
    
    @IBAction func onCancelEditCourseFormula(segue: UIStoryboardSegue){
    }
    
    @IBAction func onSaveEditCourseFormula(segue: UIStoryboardSegue){
        let courseFormulaController = segue.source as! EditCourseFormulaViewController
        let newFormula = courseFormulaController.formula.text
        
        updateFormula(newFormula)
        course!.updateFormula(newFormula)
        course!.semester!.studyPlan!.updateGrades()
        coursesTableViewController!.tableView.reloadRows(at: [IndexPath(row: coursesTableViewController!.courses.index(of: course!)!, section: 0)], with: .automatic)
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
