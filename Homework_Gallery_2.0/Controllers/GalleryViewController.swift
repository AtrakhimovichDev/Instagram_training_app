//
//  GalleryViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.07.21.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var horizontalLineView: UIView!
    @IBOutlet weak var toolbarView: CustomToolbar!
    
    let commentView = CommentView()
    
    var user: User!
    var imagesArray = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewSettings()
        setToolbarActions()
        fillImages()
        horizontalLineView.frame.size.height = 0.5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaultsManager.saveUserInfo(key: .user, user: user)
    }
    
    private func setTableViewSettings() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: ImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
    }
    
    private func setToolbarActions() {
        toolbarView.homeButton.image = UIImage(systemName: "house.fill")
        toolbarView.searchFriendsButtonAction = {
            let idetifier = String(describing: FriendsViewController.self)
            let controller = ViewControllersFactory.createFriendsViewController(identifier: idetifier, user: self.user)
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
    
    private func fillImages() {
        var usersUUID = user.friends
        usersUUID.append(user.identifier)
        imagesArray = UserDefaultsManager.getImages(usersUUID: usersUUID, key: .image)
        imagesArray.sort { $0.date > $1.date }
    }

    @IBAction func chatButtonPressed(_ sender: Any) {
        commentView.inputField.becomeFirstResponder()
    }
}

extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(image: imagesArray[indexPath.item], user: user, tableViewWidth: tableView.frame.width)
        return cell
    }
}

extension GalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}



