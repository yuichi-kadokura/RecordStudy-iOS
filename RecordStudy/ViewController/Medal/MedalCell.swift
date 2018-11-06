//
//  MedalCell.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/08/16.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

class MedalCell: UICollectionViewCell {
    
    @IBOutlet weak var medalImage: UIImageView!
    
    @IBOutlet weak var newImage: UIImageView!
    
    @IBOutlet weak var count: UILabel!

    @IBAction func tapButton(_ sender: Any) {
        newImage.isHidden = true
    }
}
