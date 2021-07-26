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
    
    var user: User!
    var imagesArray = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewSettings()
        setToolbarActions()
        fillImages()
        horizontalLineView.frame.size.height = 0.5
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
        guard let user = user else {
            return
        }
        for userFriend in user.friends {
            for image in userFriend.images {
                imagesArray.append(image)
            }
        }
        for image in user.images {
            imagesArray.append(image)
        }
        imagesArray.sort { $0.date > $1.date }
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
        cell.setup(image: imagesArray[indexPath.item], tableViewWidth: tableView.frame.width)
        return cell
    }
}

extension GalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}



