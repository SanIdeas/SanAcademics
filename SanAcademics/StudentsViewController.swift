//
//  StudentsViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 13-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class StudentsViewController: UIViewController {
    @IBOutlet weak var studentName: UITextField!
    var student: Student?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCreatedStudent(){
        let context = getContext()
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        
        do{
            let students = try context.fetch(fetchRequest)
            if(students.count > 0){
                student = students[0]
            }
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "StudyPlansSegue"){
            return !studentName.text!.isEmpty   // Perform segue only if is not empty
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "StudyPlansSegue"){
            // Save student
            let context = getContext()
            let name = studentName.text
            let student = Student(context: context)
            
            student.name = name
            do{
                try context.save()
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
            // Send data
            let navigationController = segue.destination as! UINavigationController
            let studyPlansController = navigationController.topViewController as! StudyPlansTableViewController
            
            studyPlansController.student = student
        }
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
