//
//  FriendsViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var toolbarView: CustomToolbar!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var usersArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUsersArray()
        setTableViewSettings()
        setToolbarSettings()
    }
    
    private func fillUsersArray() {
        if var allUsers = UsersManager.getUserInfo(key: .user) as? [User] {
            allUsers = allUsers.filter { $0.username != user.username }
            usersArray = allUsers
        }
    }
    
    private func setTableViewSettings() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: FriendTableViewCell.self),bundle: nil), forCellReuseIdentifier: FriendTableViewCell.identifier)
    }
    
    private func setToolbarSettings() {
        toolbarView.searchFriendsButton.image = UIImage(systemName: "magnifyingglass.circle.fill")
        toolbarView.homeButtonAction = {
            let idetifier = String(describing: GalleryViewController.self)
            let controller = ViewControllersFactory.createGalleryViewController(identifier: idetifier, user: self.user)
            self.navigationController?.pushViewController(controller, animated: false)

        }
        toolbarView.addImageButtonAction = {
            let idetifier = String(describing: NewPhotoViewController.self)
            let controller = ViewControllersFactory.createNewPhotoViewController(identifier: idetifier, user: self.user)
            self.navigationController?.pushViewController(controller, animated: false)
        }
        toolbarView.profileButtonAction = {
            let idetifier = String(describing: ProfileViewController.self)
            let controller = ViewControllersFactory.createProfileViewController(identifier: idetifier, user: self.user)
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UsersManager.saveUserInfo(key: .user, value: user)
    }
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        var isFollowed = false
        if user.friends.contains(where: { $0.username == usersArray[indexPath.row].username }) {
            isFollowed = true
        }
        cell.usernameLabel.text = usersArray[indexPath.row].username
        cell.setup(user: user, friend: usersArray[indexPath.row], isFollowed: isFollowed)
        return cell
    }
    
    
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

