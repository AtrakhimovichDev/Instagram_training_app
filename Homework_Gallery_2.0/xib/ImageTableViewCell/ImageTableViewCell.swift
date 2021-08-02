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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileFooterImageView: UIImageView!

    var isLiked = false
    var user: User!
    var image: Image!

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

    func setup(image: Image, user: User, tableViewWidth: CGFloat) {
        self.user = user
        self.image = image
    
        if let userOwner = UserDefaultsManager.getUser(identifier: image.ownerIdentifier, key: .user) {
            userNameLabel.text = userOwner.username
            locationLabel.text = image.location
            likesLabel.text = "Likes: \(image.usernamesLikes.count)"

            let profileImage = FilesManager.getProfileImage(username: userOwner.username)
            profileImageView.image = profileImage
            profileFooterImageView.image = profileImage

            let picture = FilesManager.getImage(image: image)
            pictureView.image = picture
            imageHeightConstraint.constant = tableViewWidth * (picture.size.height / picture.size.width)

            let usersArray = image.usernamesLikes.filter { $0 == user.identifier }
            if usersArray.count != 0 {
                isLiked = true
                changeLikeButton()
            }
        }
    }

    @IBAction func likeButtonPressed(_ sender: Any) {
        isLiked = !isLiked
        changeLikeButton()
        if isLiked {
            image.usernamesLikes.append(user.identifier)
        } else {
            image.usernamesLikes = image.usernamesLikes.filter({ $0 != user.identifier})
        }
        likesLabel.text = "Likes: \(image.usernamesLikes.count)"
        UserDefaultsManager.saveImage(image: image, key: .image)
    }

    @IBAction func commentButtonPressed(_ sender: Any) {
    }

    @IBAction func addCommentButtonPressed(_ sender: Any) {
    }

    private func changeLikeButton() {
        if isLiked {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .black
        }
    }
}
