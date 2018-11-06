//
//  MedalViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/08/16.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

/// ViewControllerの背景を透明にしたいのでstoryboardでPresentation=Over Current Contextにしています。
class MedalViewController: UIViewController {

    var medals = ParsistManager.loadMedals()

    @IBOutlet weak var viewMedalCollection: UICollectionView!
    
    @IBAction func tapView(_ sender: Any) {
        view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMedalCollection.backgroundColor = .clear
        viewMedalCollection.backgroundView = UIView(frame: CGRect.zero)
    }
}

extension MedalViewController: UICollectionViewDataSource {

    /// MARK: required
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medals.count
    }

    // 一覧表示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let medalCell: MedalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MedalCell
        if medals[indexPath.row].count > 0 {
            medalCell.medalImage.image = UIImage(named: String(format: "sano%04d", (indexPath as NSIndexPath).row + 1))
            medalCell.newImage.isHidden = !medals[indexPath.row].isNew
        } else {
            // 0枚の場合はシルエット
            medalCell.medalImage.image = UIImage(named: String(format: "sano%04d", (indexPath as NSIndexPath).row + 1))?.withRenderingMode(.alwaysTemplate)
            medalCell.medalImage.tintColor = UIColor.black
            medalCell.newImage.isHidden = true
        }
        if medals[indexPath.row].count > 1 {
            medalCell.count.text = String(format: "×%02d", medals[indexPath.row].count)
        } else {
            medalCell.count.text = ""
        }

        return medalCell
    }

    /// MARK: optional
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MedalViewController: UICollectionViewDelegate {
    // セルを選択した時に発生するイベント
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // NEWフラグを落とす
        if medals[(indexPath as NSIndexPath).row].isNew {
            medals[(indexPath as NSIndexPath).row].isNew = false
            ParsistManager.save(medalModels: medals)
            // 再描画
            viewMedalCollection.reloadData()
        }
        
        // メダル表示
        if medals[indexPath.row].count > 0 {
            let storyboard: UIStoryboard = UIStoryboard(name: "GetMedal", bundle: nil)
            let vc: GetMedalViewController = storyboard.instantiateInitialViewController() as! GetMedalViewController
            vc.medalNo = (indexPath as NSIndexPath).row
            present(vc, animated: true, completion: nil)
        }
    }
}
