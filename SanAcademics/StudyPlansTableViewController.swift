//
//  StudyPlansTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 13-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class StudyPlansTableViewController: UITableViewController {
    var studyPlans = [StudyPlan]()
    var student: Student?

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudyPlans()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return studyPlans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyPlanCell", for: indexPath) as! StudyPlanTableViewCell

        // Configure the cell...
        let studyPlan = studyPlans[indexPath.row]
        
        cell.name.text = studyPlan.name
        cell.academicPriority.text = "PA: \(studyPlan.academicPriority!)"

        return cell
    }
    
    func getStudyPlans(){
        let context = getContext()
        let fetchRequest: NSFetchRequest<StudyPlan> = StudyPlan.fetchRequest()
        
        do{
            studyPlans = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    @IBAction func onClickAddStudyPlanButton(_ sender: Any) {
        let alert = UIAlertController(title: "Nuevo Plan de Estudio", message: "Agregar Plan de Estudio", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        alert.addTextField{(textField) in
            textField.placeholder = "Nombre"
        }
        
        // Cancel Button
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(_) in
        }))
        
        // Confirm Button
        alert.addAction(UIAlertAction(title: "Crear", style: .default, handler: {(_) in
            let name = alert.textFields![0]
            let context = getContext()
            let studyPlan = StudyPlan(context: context)
            
            studyPlan.name = name.text
            studyPlan.studyPlanInverse = self.student
            
            do{
                try context.save()
                
                let newIndexPath = IndexPath(row: self.studyPlans.count, section: 0)
                self.studyPlans.append(studyPlan)
                self.tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! StudyPlanTableViewCell
        let index = self.tableView.indexPath(for: cell)!.row
        
        let splitView = segue.destination as! SemestersSplitViewController
        let navigationController = splitView.viewControllers[0] as! UINavigationController
        let semestersController = navigationController.topViewController as! SemestersTableViewController
        
        semestersController.studyPlan = studyPlans[index]
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
