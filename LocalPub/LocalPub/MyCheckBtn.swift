//
//  MyCheckBtn.swift
//  LocalPub
//
//  Created by Kyunghyun Lee on 2022/02/06.
//

import Foundation
import UIKit

class MyCheckBtn: UIButton {
    var isActivated : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("MyCheckBtn - awakeFromNib() called")
    }
    
    func setState(_ newValue: Bool){
        print("MyCheckBtn - setState() called / newValue: \(newValue)")
        
        //1. 현재 버튼의 상태 변경
        self.isActivated = newValue

        //2. 변경된 상태에 따른 이미지 변경
        
        let activatedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)).withRenderingMode(.alwaysOriginal)
        let normalImage = UIImage(systemName: "checkmark.circle")?.withTintColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)).withRenderingMode(.alwaysOriginal)
        self.setImage(self.isActivated ? activatedImage : normalImage, for: .normal)
    }
}

