//
//  EditAssessmentTypeFormulaViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 23-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class EditAssessmentTypeFormulaViewController: UIViewController {
    @IBOutlet weak var formula: UITextView!
    
    var assessmentType: AssessmentType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formula.text = assessmentType!.formula
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
