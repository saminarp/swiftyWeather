//
//  WeatherTableViewCell.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-14.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    //MARK: Cell outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
