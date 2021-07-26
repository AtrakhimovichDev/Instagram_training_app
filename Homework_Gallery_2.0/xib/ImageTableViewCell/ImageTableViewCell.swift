//
//  ImageTableViewCell.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    static var identifier = "ImageTableViewCell"
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var profileFooterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForReuse() {
        profileImageView.image = UIImage(named: "default_user_image")
        profileFooterImageView.image = UIImage(named: "default_user_image")
    }
    
    private func setup() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileFooterImageView.layer.cornerRadius = profileFooterImageView.frame.width / 2
    }
    
    func setup(image: Image, tableViewWidth: CGFloat) {
        userNameLabel.text = image.ownerUsername
        locationLabel.text = image.location
        likesLabel.text = "Likes: \(image.usersLikes.count)"
        
        let profileImage = FilesManager.getProfileImage(username: image.ownerUsername)
        profileImageView.image = profileImage
        profileFooterImageView.image = profileImage
        
        let picture = FilesManager.getImage(image: image)
        pictureView.image = picture
        imageHeightConstraint.constant = tableViewWidth * (picture.size.height / picture.size.width)  
    }
}
