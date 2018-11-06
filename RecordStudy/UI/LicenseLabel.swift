//
//  LicenseLabel.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/11/06.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

class LicenseLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filePath = Bundle.main.path(forResource: "License", ofType:"plist")
        let plist = NSDictionary(contentsOfFile: filePath!)!
        text = plist["License text"] as? String
    }
}
