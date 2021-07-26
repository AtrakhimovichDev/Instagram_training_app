//
//  FriendTableViewCell.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    static var identifier = "FriendTableViewCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
   
    var user: User?
    var friend: User?
    var isFollowed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        followButton.layer.cornerRadius = 5
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(user: User, friend: User, isFollowed: Bool) {
        self.user = user
        self.friend = friend
        self.isFollowed = isFollowed
        changeButton()
    }
    
    private func changeButton() {
        if isFollowed {
            followButton.setTitle("Remove", for: .normal)
            followButton.setTitleColor(.black, for: .normal)
            followButton.backgroundColor = .white
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0, green: 0.6054090858, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        isFollowed = !isFollowed
        changeButton()
        if isFollowed {
            saveToFollowing()
        } else {
            removeFromFollowing()
        }
    }
    
    private func saveToFollowing() {
        if let friend = self.friend {
            user?.friends.append(friend)
        }
    }
    
    private func removeFromFollowing() {
        user?.friends = user?.friends.filter { $0.username != friend?.username } ?? [User]()
    }
}
