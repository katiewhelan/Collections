//
//  DisplayCellTableViewCell.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 4/10/21.
//

import UIKit

class DisplayCell: UITableViewCell {

    @IBOutlet weak var DisplayLabelSub: UILabel!
    @IBOutlet weak var displayCellImage: UIImageView!
    @IBOutlet weak var displayCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        super.setSelected(selected, animated: animated)
        removeSelectionStyleOnCell()

        // Configure the view for the selected state
    }
    
}

extension UITableViewCell{
    func removeSelectionStyleOnCell(){
        self.selectionStyle = .none
    }
    
}
