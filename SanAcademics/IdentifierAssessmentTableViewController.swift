//
//  IdentifierAssessmentTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 24-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class IdentifierAssessmentTableViewController: UITableViewController {
    var assessmentType: AssessmentType?
    var assessments = [Assessment]()
    var selectedId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAssessments()
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
        return assessments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierAssessmentCell", for: indexPath) as! IdentifierAssessmentTableViewCell
        
        // Configure the cell...
        cell.identifier.text = assessments[indexPath.row].identifier
        cell.name.text = assessments[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddAssessmentIdentifierSegue"){
            let cell = sender as! IdentifierAssessmentTableViewCell
            selectedId = cell.identifier.text
        }
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
}
