//
//  AddScheduleTableViewCell.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 22-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class AddScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var block: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
