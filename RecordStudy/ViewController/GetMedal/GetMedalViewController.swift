//
//  GetMedalViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/09/21.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

class GetMedalViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    var medalNo: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let medal = medalNo {
            image.image = UIImage(named: String(format: "sano%04d", medal + 1))
        }
    }
    
    @IBAction func touchDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
