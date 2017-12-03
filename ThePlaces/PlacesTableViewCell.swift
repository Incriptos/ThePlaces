//
//  PlacesTableViewCell.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 01.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
