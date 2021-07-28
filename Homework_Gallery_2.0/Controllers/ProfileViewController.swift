//
//  ProfileViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 23.07.21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbarView: CustomToolbar!
   
    private let fileManager = FileManager.default
    private lazy var mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var imagesDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbarSettings()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        profileImageView.addGestureRecognizer(tapGesture)
        
        profileImageView.image = FilesManager.getProfileImage(username: user.username)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        usernameLabel.text = user.username
        postNumberLabel.text = "\(user.images.count)"
        followingNumberLabel.text = "\(user.friends.count)"
    }
    
    @objc func tapAction() {
        showAlert()
    }
    
    private func showAlert() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: "Choose media source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Media library", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if self.checkCameraPermissions() {
                picker.sourceType = .camera
                self.present(picker, animated: true)
            } else {
                self.showErrorAlert()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print(1)
        }))
        present(alert, animated: true)
    }
    
    func checkCameraPermissions() -> Bool {
        #if targetEnvironment(simulator)
        return false // На симуляторе камера не работает, даже не будем пробовать запускать
        #else
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined, .authorized:
            return true
        default:
            return false
        }
        #endif
    }
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "No persmissions for camera usage, check device app settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //self.quit()
        }))
        present(alert, animated: true)
    }
    private func setToolbarSettings() {
        toolbarView.profileButton.image = UIImage(systemName: "book.closed.fill")
        toolbarView.homeButtonAction = {
            let idetifier = String(describing: GalleryViewController.self)
            let controller = ViewControllersFactory.createGalleryViewController(identifier: idetifier, user: self.user)
            self.navigationController?.pushViewController(controller, animated: false)

        }
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
    }

}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = UserDefaultsManager.getImage(imageUUID: user.images[indexPath.item], key: .image)
        cell.imageView.image = FilesManager.getImage(image: image)
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 4) / 3, height: (view.frame.width - 4) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            let imageName = "profileImage.png"
            let folder = user.username
            let imageInfo = Image(identifier: UUID(), imageName: imageName, folder: folder, location: "", date: Date(), ownerUsername: user.identifier)
            UserDefaultsManager.saveImage(image: imageInfo, key: .image)
            FilesManager.saveImage(in: imagesDirectoryURL, imageInfo: imageInfo, image: image)
        }
        picker.dismiss(animated: true)
    }
}
