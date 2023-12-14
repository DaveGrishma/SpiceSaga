//
//  UserProfileCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 11/12/23.
//

import UIKit
import Kingfisher

class UserProfileCell: UITableViewCell {
    
    @IBOutlet private var imageViewUserProfile: UIImageView!
    @IBOutlet private var labelUserName: UILabel!
    @IBOutlet private var labelEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareUserDetails() {
        labelUserName.text = FirebaseAuthManager.shared.currentUser?.userName ?? ""
        labelEmail.text = FirebaseAuthManager.shared.currentUser?.email ?? ""
        let userId = FirebaseAuthManager.shared.userID
        FirebaseRealTimeStorage.shared.getProfilePictureURL(forUserID: userId) { url in
            if let userUrl = url {
                self.imageViewUserProfile.kf.setImage(with: userUrl)
            }
        }
        
    }
}
