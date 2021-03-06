//
//  FunctionAssessmentTypeTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 24-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class FunctionCourseTableViewController: UITableViewController {
    var selectedFunction: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "AddCourseFunctionSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddCourseFunctionSegue"){
            let cell = sender as! UITableViewCell
            let index = tableView.indexPath(for: cell)!.row
            
            switch(index){
                case 0:
                    selectedFunction = "sqrt( )"
                    break
                case 1:
                    selectedFunction = "log( )"
                    break
                case 2:
                    selectedFunction = "ln( )"
                    break
                case 3:
                    selectedFunction = "log2( )"
                    break
                case 4:
                    selectedFunction = "exp( )"
                    break
                case 5:
                    selectedFunction = "ceil( )"
                    break
                case 6:
                    selectedFunction = "floor( )"
                    break
                case 7:
                    selectedFunction = "sin( )"
                    break
                case 8:
                    selectedFunction = "cos( )"
                    break
                case 9:
                    selectedFunction = "tan( )"
                    break
                default:
                    selectedFunction = "sqrt( )"
                    break
            }
        }
    }
}
