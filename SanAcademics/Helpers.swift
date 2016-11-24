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
        if(formula != nil && !formula!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
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
            course.semester!.studyPlan!.updateGrades()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func calculateFormula(_ formula: String?) -> Double{
        if(formula != nil && !formula!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
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

extension StudyPlan{
    func updateGrades(){
        let context = self.managedObjectContext!
        self.average = calculateAverage()
        self.academicPriority = calculateAcademicPriority()
        
        do{
            try context.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func calculateAverage() -> Double{
        let courses = getCourses()
        if(courses.count == 0){
            return 0
        }
        
        var average: Double = 0
        for course in courses{
            average += course.average
        }
        
        average /= Double(courses.count)
        return average
    }
    
    func calculateAcademicPriority() -> Double{
        let courses = getCourses()
        let semesters = getSemesters()
        
        if(semesters.count == 0){
            return 0
        }
        
        let S = Double(semesters.count)
        let CT = calculateCT(courses)
        let CA = calculateCA(courses)
        let sum = calculateSum(courses)
        
        var PA: Double = 0
        PA += 100
        PA *= CA / CT
        PA *= sum
        PA /= 14*(pow(S, 1.06))
        PA *= Double(semesters.last!.fae)
        
        return PA
    }
    
    func calculateCT(_ courses: [Course]) -> Double{
        var CT: Double = 0
        for course in courses{
            CT += Double(course.credits)
        }
        
        return CT
    }
    
    func calculateCA(_ courses: [Course]) -> Double{
        var CA: Double = 0
        for course in courses{
            if(course.average >= 55){
                CA += Double(course.credits)
            }
        }
        
        return CA
    }
    
    func calculateSum(_ courses: [Course]) -> Double{
        var sum: Double = 0
        for course in courses{
            sum += Double(course.credits) * course.average
        }
        
        return sum
    }
    
    func getSemesters() -> [Semester]{
        var semesters = [Semester]()
        
        let context = getContext()
        let predicate = NSPredicate(format: "studyPlan == %@", self)
        let fetchRequest: NSFetchRequest<Semester> = Semester.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            semesters = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
        
        return semesters
    }
    
    func getCourses() -> [Course]{
        var courses = [Course]()
        
        let context = getContext()
        let predicate = NSPredicate(format: "semester.studyPlan == %@", self)
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            courses = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
        
        return courses
    }
}
