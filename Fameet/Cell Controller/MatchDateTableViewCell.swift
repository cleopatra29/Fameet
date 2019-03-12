//
//  MatchDateTableViewCell.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 04/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseUI

class MatchDateTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passData = [NSDate : [String]]()
    var passKey = NSDate()
    var userImage = UIImage()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionViewMatchDates: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passData[passKey]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reference = Storage.storage().reference().child("userProfilePicture/\(passData[passKey]![indexPath.row]).jpg")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellName", for: indexPath) as? MatchDateInTableViewCellCollectionViewCell
        
        cell?.availMemberPic.sd_setImage(with: reference, placeholderImage: UIImage(named: "Propic"))
        cell?.availMemberPic.clipsToBounds = true
        cell?.availMemberPic.layer.cornerRadius = (cell?.availMemberPic.frame.size.width)!/2
        cell?.availMemberPic.layer.masksToBounds = true
        print("passKey : \(passKey)")
        print("passData index row : \(passData[passKey])")
        
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
