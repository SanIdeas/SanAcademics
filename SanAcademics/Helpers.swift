//
//  Helpers.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 21-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//
import UIKit
import CoreData
import MathParser

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension Course {
    func updateFormula(_ formula: String?) {
        let context = self.managedObjectContext!
        self.formula = formula
        self.average = calculateFormula(formula)
        
        do{
            try context.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func calculateFormula(_ formula: String?) -> Double{
        if(formula != nil){
            var result: Double = 0
            let variables = getVariables()
            
            do{
                result = try formula!.evaluate(variables)
            }
            catch{
                print("Request error: \(error)")
            }
            
            return result
        }
        
        return 0
    }
    
    func getVariables() -> [String: Double] {
        var variables = [String: Double]()
        
        let context = getContext()
        let predicate = NSPredicate(format: "course == %@", self)
        let fetchRequest: NSFetchRequest<AssessmentType> = AssessmentType.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            let assessmentTypes = try context.fetch(fetchRequest)
            for assessmentType in assessmentTypes {
                variables[assessmentType.identifier!] = assessmentType.average
            }
        }
        catch{
            print("Request error: \(error)")
        }
        
        return variables
    }
}

extension AssessmentType {
    func updateFormula(_ formula: String?) {
        let context = self.managedObjectContext!
        self.formula = formula
        self.average = calculateFormula(formula)
        
        let course = self.course!
        course.average = course.calculateFormula(course.formula)
        
        do{
            try context.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func calculateFormula(_ formula: String?) -> Double{
        if(formula != nil){
            var result: Double = 0
            let variables = getVariables()
            
            do{
                result = try formula!.evaluate(variables)
            }
            catch{
                print("Request error: \(error)")
            }
            
            return result
        }
        
        return 0
    }
    
    func getVariables() -> [String: Double] {
        var variables = [String: Double]()
        
        let context = getContext()
        let predicate = NSPredicate(format: "assessmentType == %@", self)
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            let assessments = try context.fetch(fetchRequest)
            for assessment in assessments {
                variables[assessment.identifier!] = assessment.grade
            }
        }
        catch{
            print("Request error: \(error)")
        }
        
        return variables
    }
}
