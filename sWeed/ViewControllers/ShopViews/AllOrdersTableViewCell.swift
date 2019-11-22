//
//  AllOrdersTableViewCell.swift
//  sWeed
//
//  Created by Atahan on 15/11/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit

class AllOrdersTableViewCell: UITableViewCell {
    @IBOutlet weak var RiderNameText: UILabel!
    @IBOutlet weak var OrderNumberText: UILabel!
    @IBOutlet weak var NumberOfItemsText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
