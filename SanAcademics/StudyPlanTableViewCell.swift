//
//  StudyPlanTableViewCell.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 13-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class StudyPlanTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var academicPriority: UILabel!
    @IBOutlet weak var average: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
