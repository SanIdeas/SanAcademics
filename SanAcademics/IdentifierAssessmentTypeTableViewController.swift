//
//  IdentifierAssessmentTypeTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 23-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class IdentifierAssessmentTypeTableViewController: UITableViewController {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierAssessmentTypeCell", for: indexPath) as! IdentifierAssessmentTypeTableViewCell

        // Configure the cell...
        cell.identifier.text = assessmentTypes[indexPath.row].identifier
        cell.name.text = assessmentTypes[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddAssessmentTypeIdentifierSegue"){
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
}
