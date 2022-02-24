 //
//  LanguageTableViewCell.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
  
    
    @IBOutlet weak var languageCodeLabel: UILabel!
    @IBOutlet weak var languageLevelImage: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(with userLanguageInfo: LanguageInfo) {
        languageLabel.text = userLanguageInfo.language.toString()
        languageLabel.textColor = UIColor.black
        languageCodeLabel.text = userLanguageInfo.language.toString().prefix(2).uppercased()
        languageCodeLabel.textColor = UIColor.purple
        languageLevelImage.image = UIImage(named: userLanguageInfo.level.toString())
    }
    
    func updateCellInit() {
        languageLabel.text = "Add Language"
        languageLabel.textColor = UIColor.opaqueSeparator
        languageCodeLabel.text = ""
        languageLevelImage.image = nil
    }
}
