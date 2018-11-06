//
//  ResultInputViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/07/17.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

protocol ResultInputDelegate {
    func inputValue(date: Date, time: Date, segue: RecordStudySegue)
}

class ResultInputViewController: UIViewController {

    @IBOutlet weak var segueLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var hanamaruView: UIImageView!
    
    // 共通Viewなので導線によって切り替えます。
    var segue: RecordStudySegue!
    var delegate: ResultInputDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        changeDate()
    }

    @IBAction func dateValueChanged(_ sender: Any) {
        changeDate()
    }

    @IBAction func timeValueChanged(_ sender: Any) {
        timeLabel.text = timePicker.date.toHmm()
        setAchieveView()
    }

    /// 初期化処理
    private func setting() {
        guard let segueEnum = segue else {
            return
        }
        let date: Date
        switch segueEnum {
        case .homeWork:
            segueLabel.text = "しゅくだい"
            date = Setting.homeWork.load()
        case .study:
            segueLabel.text = "べんきょう"
            date = Setting.study.load()
        }
        settingLabel.text = "もくひょう \(date.toHmm())"
    }
    
    /// 日付変更処理
    private func changeDate() {
        guard let segueEnum = segue else {
            return
        }
        dateLabel.text = datePicker.date.toYMDEKanji()
        let model = ParsistManager.load(date: datePicker.date)
        switch segueEnum {
        case .homeWork:
            timePicker.date = model.homeWork
        case .study:
            timePicker.date = model.study
        }
        timeLabel.text = timePicker.date.toHmm()
        setAchieveView()
    }
    
    /// 達成View表示
    private func setAchieveView() {
        guard let segueEnum = segue else {
            return
        }
        let settingDate: Date
        switch segueEnum {
        case .homeWork:
            settingDate = Setting.homeWork.load()
        case .study:
            settingDate = Setting.study.load()
        }
        hanamaruView.isHidden = (timePicker.date < settingDate)
    }
    
    /// OKボタンタップ
    @IBAction func tapOkButton(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.inputValue(date: datePicker.date, time: timePicker.date, segue: segue)
        }
    }
    
    // 日付タップ
    @IBAction func touchDownDateLabel(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker.isHidden = !self.datePicker.isHidden
        })
    }
    
}
