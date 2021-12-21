//
//  CustomTableViewCell.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 20/12/2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var losImagicos: UIImageView!
    
    @IBOutlet weak var losLabelos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
