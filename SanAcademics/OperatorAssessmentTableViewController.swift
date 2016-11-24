//
//  OperatorAssessmentTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 24-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class OperatorAssessmentTableViewController: UITableViewController {
    var selectedOperator: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.section == 0 && indexPath.row == 0){
            return
        }
        
        performSegue(withIdentifier: "AddAssessmentOperatorSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddAssessmentOperatorSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let row = indexPath!.row
            let section = indexPath!.section
            
            switch(section){
            case 0: // Basic
                switch(row){
                case 0:
                    selectedOperator = "+"
                    break
                case 1:
                    selectedOperator = "-"
                    break
                case 2:
                    selectedOperator = "*"
                    break
                case 3:
                    selectedOperator = "/"
                    break
                case 4:
                    selectedOperator = "%"
                    break
                case 5:
                    selectedOperator = "**"
                    break
                default:
                    selectedOperator = "+"
                    break
                }
                break
            case 1: // Comparison
                switch(row){
                case 0:
                    selectedOperator = "=="
                    break
                case 1:
                    selectedOperator = "!="
                    break
                case 2:
                    selectedOperator = "<"
                    break
                case 3:
                    selectedOperator = ">"
                    break
                case 4:
                    selectedOperator = "<="
                    break
                case 5:
                    selectedOperator = ">="
                    break
                default:
                    selectedOperator = "+"
                    break
                }
                break
            case 2: // Logic
                switch(row){
                case 0:
                    selectedOperator = "&&"
                    break
                case 1:
                    selectedOperator = "||"
                    break
                case 2:
                    selectedOperator = "!"
                    break
                default:
                    selectedOperator = "+"
                    break
                }
                break
            default:
                selectedOperator = "+"
                break
            }
        }
    }

}
