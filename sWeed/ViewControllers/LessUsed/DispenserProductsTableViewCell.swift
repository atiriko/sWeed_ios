//
//  DispenserProductsTableViewCell.swift
//  sWeed
//
//  Created by Atahan on 21/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class DispenserProductsTableViewCell: UITableViewCell {
    @IBAction func ProductDisableEnableSwitch(_ sender: UISwitch) {
    }
    @IBOutlet weak var ProductDisableEnableText: UILabel!
    @IBOutlet weak var ItemPriceText: UILabel!
    @IBOutlet weak var ItemNameText: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
