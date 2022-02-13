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
        
        let activatedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(#colorLiteral(red: 0.7422353625, green: 0.2466334403, blue: 0.8593617082, alpha: 1)).withRenderingMode(.alwaysOriginal)
        let normalImage = UIImage(systemName: "checkmark.circle")?.withTintColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).withRenderingMode(.alwaysOriginal)
        self.setImage(self.isActivated ? activatedImage : normalImage, for: .normal)
    }
}

