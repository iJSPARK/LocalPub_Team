 //
//  LanguageTableViewCell.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
  
    @IBOutlet weak var languageLevelLabel: UILabel!
    
    @IBOutlet weak var languageLevelImage: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func update(with language: String) {
//        languageLabel.text = language
//        languageLevelImage.image =
//    }

}
