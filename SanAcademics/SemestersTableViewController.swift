//
//  SemestersTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 13-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class SemestersTableViewController: UITableViewController {
    var studyPlan: StudyPlan?
    var semesters = [Semester]()
    
    //var semesterss: [String] = ["2016-1", "2015-2", "2015-1"]
    //var subtitles: [String] = ["PA: 3600", "PA: 5210", "PA: 4623"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSemesters()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.semesters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell", for: indexPath) as! SemesterTableViewCell

        // Configure the cell...
        let semester = semesters[indexPath.row]
        cell.semester.text = "\(semester.number) - \(semester.year)"
        cell.subtitle.text = "PA: \(studyPlan!.academicPriority!)"
        return cell
    }
    
    func getSemesters(){
        let context = getContext()
        let predicate = NSPredicate(format: "studyPlan == %@", studyPlan!)
        let fetchRequest: NSFetchRequest<Semester> = Semester.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            semesters = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let contentView = button.superview!
        let cell = contentView.superview! as! SemesterTableViewCell
        let index = self.tableView.indexPath(for: cell)!.row
        
        let semesterViewController = segue.destination as! SemesterViewController
        semesterViewController.semester = semesters[index]
    }

    @IBAction func onClickAddSemesterButton(_ sender: Any) {
        let alert = UIAlertController(title: "Nuevo semestre", message: "Agregar semestre", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        alert.addTextField{(textField) in
            textField.placeholder = "Año"
        }
        
        alert.addTextField{(textField) in
            textField.placeholder = "Número"
        }

        // Cancel Button
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(_) in
        }))
        
        // Confirm Button
        alert.addAction(UIAlertAction(title: "Crear", style: .default, handler: {(_) in
            let numberField = alert.textFields![0]
            let yearField = alert.textFields![1]
            
            let context = getContext()
            let semester = Semester(context: context)
            
            semester.number = Int16(numberField.text!)!
            semester.year = Int16(yearField.text!)!
            semester.studyPlan = self.studyPlan
            
            do{
                try context.save()
                self.getSemesters()
                self.tableView.reloadData()
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
