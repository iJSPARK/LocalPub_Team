//
//  CustomButton.swift
//  LocalPub
//
//  Created by Junseo Park on 2/2/22.
//

import UIKit

class CustomButton: UIButton {

    enum ButtonState {
        case normal
        case disabled
    }
        
    private var disabledBackgroundColor: UIColor?
    private var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }
    
    // 4. change background color on isEnabled value changed
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
            }
            else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    // 5. our custom functions to set color for different state
    
    func setBackgroundColor(color: UIColor, for state: ButtonState) {
        switch state {
        case .disabled:
            disabledBackgroundColor = color
        case .normal:
            defaultBackgroundColor = color
        }
    }
}
