//
//  Tutorial01ViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/09/25.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

class Tutorial01ViewController: UIViewController, SettingView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homeWorkView: UIView!
    @IBOutlet weak var studyView: UIView!
    @IBOutlet weak var homeWorkLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bg: UIImageView!
    
    var selectedView: Setting = .homeWork
    
    @IBAction func tapNext(_ sender: Any) {
        if selectedView == .homeWork {
            let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial01", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! Tutorial01ViewController
            vc.selectedView = .study
            show(vc, sender: nil)
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
            // 初期化済みフラグ
            ParsistManager.save(isInitialized: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedView == .homeWork {
            navigationController?.title = "宿題の目標時間"
            titleLabel.text = "宿題の一日の目標時間を設定してください。"
            bg.image = UIImage(named: "sano0001")
        } else {
            navigationController?.title = "勉強の目標時間"
            titleLabel.text = "勉強の一日の目標時間を設定してください。"
            bg.image = UIImage(named: "sano0003")
        }
        innerTouchDown(newSelectedView: selectedView)
        onValueChanged(datePicker)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ラベル初期表示
        self.homeWorkLabel.text = Setting.homeWork.load().toHmKanji()
        self.studyLabel.text = Setting.study.load().toHmKanji()
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        selectedView.getLabel(self).text = datePicker.date.toHmKanji()
        selectedView.save(date: datePicker.date)
    }
    
    func innerTouchDown(newSelectedView: Setting) {
        newSelectedView.getView(self).alpha = 1.0
        newSelectedView.getView(self).backgroundColor = .lightGray
        datePicker.date = newSelectedView.load()
        selectedView = newSelectedView
    }
    
    @IBAction func clickHomeWork(_ sender: Any) {
        if selectedView == .homeWork {
            return
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clickStudy(_ sender: Any) {
        if selectedView == .study {
            return
        }
        let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial01", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! Tutorial01ViewController
        vc.selectedView = .study
        show(vc, sender: nil)
    }
}
