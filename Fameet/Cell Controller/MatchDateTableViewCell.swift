//
//  MatchDateTableViewCell.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 04/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MatchDateTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passData = [NSDate : [String]]()
    var passKey = NSDate()
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionViewMatchDates: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
        return passData[passKey]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reference = Storage.storage().reference().child("userProfilePicture/\(passData[passKey]![indexPath.row]).jpg")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellName", for: indexPath) as? MatchDateInTableViewCellCollectionViewCell
        cell?.availMemberPic.sd_setImage(with: reference, placeholderImage: UIImage(named: "boy"))
        cell?.availMemberPic.clipsToBounds = true
        cell?.availMemberPic.layer.cornerRadius = (cell?.availMemberPic.frame.size.width)!/2
        cell?.availMemberPic.layer.masksToBounds = true
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewMatchDates.delegate = self
        self.collectionViewMatchDates.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

/*
 //
 //  MatchDateTableViewCell.swift
 //  FinalChallengeVessel
 //
 //  Created by Terretino on 04/02/19.
 //  Copyright © 2019 Terretino. All rights reserved.
 //
 
 import UIKit
 import Firebase
 
 
 class MatchDateTableViewCell: UITableViewCell {
 // masukin datanya
 //    var match = DataFetcher.
 var passData = [NSDate : [String]]()
 var passKey = NSDate()
 
 @IBOutlet weak var dateLabel: UILabel!
 @IBOutlet weak var collectionViewMatchDates: UICollectionView!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 self.collectionViewMatchDates.delegate = self
 self.collectionViewMatchDates.dataSource = self
 // Initialization code
 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
 print("ini passData : \(self.passData)")
 self.collectionViewMatchDates.reloadData()
 }
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 }
 }
 
 extension MatchDateTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 //        return dateData.dictOfDates[date]?.count ?? 0
 return passData[passKey]!.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellName", for: indexPath) as? MatchDateInTableViewCellCollectionViewCell
 
 cell?.nameOfOwnerDateLabel.text = passData[passKey]?[indexPath.row]
 self.collectionViewMatchDates.reloadData()
 return cell!
 }
 }

 */
