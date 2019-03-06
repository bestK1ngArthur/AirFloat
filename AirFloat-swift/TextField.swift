//
//  TextField.swift
//  AirFloat-swift
//
//  Created by a.belkov on 02/03/2019.
//

import UIKit

class TextField: UITextField {

    let textInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
}
