//
//  IdentifierAssessmentTypeTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 23-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class IdentifierCourseTableViewController: UITableViewController {
    var course: Course?
    var assessmentTypes = [AssessmentType]()
    var selectedId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        getAssessmentTypes()
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
        return assessmentTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCourseCell", for: indexPath) as! IdentifierAssessmentTypeTableViewCell

        // Configure the cell...
        cell.identifier.text = assessmentTypes[indexPath.row].identifier
        cell.name.text = assessmentTypes[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddCourseIdentifierSegue"){
            let cell = sender as! IdentifierAssessmentTypeTableViewCell
            selectedId = cell.identifier.text
        }
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
