//
//  SettingViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/06/11.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, SettingView {

    @IBOutlet weak var homeWorkView: UIView!
    @IBOutlet weak var studyView: UIView!
    @IBOutlet weak var homeWorkLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    var selectedView: Setting = .homeWork
    
    override func viewDidLoad() {
        super.viewDidLoad()
        innerTouchDown(newSelectedView: .study)
        onValueChanged(datePicker)
        innerTouchDown(newSelectedView: .homeWork)
        onValueChanged(datePicker)
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        selectedView.getLabel(self).text = datePicker.date.toHmKanji()
        selectedView.save(date: datePicker.date)
    }
    
    @IBAction func touchDownHomeWorkButton(_ sender: Any) {
        innerTouchDown(newSelectedView: .homeWork)
    }
    
    @IBAction func touchDownStudyButton(_ sender: Any) {
        innerTouchDown(newSelectedView: .study)
    }
    
    func innerTouchDown(newSelectedView: Setting) {
        selectedView.getView(self).backgroundColor = .white
        newSelectedView.getView(self).backgroundColor = .lightGray
        datePicker.date = newSelectedView.load()
        selectedView = newSelectedView
    }
}
