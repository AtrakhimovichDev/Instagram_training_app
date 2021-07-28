//
//  NewPhotoViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 22.07.21.
//

import UIKit
import AVKit
class NewPhotoViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var postPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var user: User!
    private let fileManager = FileManager.default
    private lazy var mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var imagesDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.isHidden = true
        postPhotoButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            self.quit()
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
            self.quit()
        }))
        present(alert, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        quit()
    }
    
    @IBAction func postPhotoButtonPressed(_ sender: Any) {
        let imageName = "\(Int(Date().timeIntervalSince1970)).png"
        let folder = user.username
        let location = locationTextField.text ?? ""
        let imageIdentifier = UUID()
        let image = Image(identifier: imageIdentifier, imageName: imageName, folder: folder, location: location, date: Date(), ownerUsername: user.identifier)
        user.images.append(imageIdentifier)
        saveImageInFolder(image: image)
        UserDefaultsManager.saveImage(image: image, key: .image)
        UserDefaultsManager.saveUserInfo(key: .user, user: user)
        quit()
    }
    
    private func saveImageInFolder(image: Image) {
        if let picture = imageView.image {
            FilesManager.saveImage(in: imagesDirectoryURL, imageInfo: image, image: picture)
        }
    }
    
    private func quit() {
        let idetifier = String(describing: GalleryViewController.self)
        let controller = ViewControllersFactory.createGalleryViewController(identifier: idetifier, user: self.user)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

extension NewPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[.editedImage] as? UIImage
        imageView.image = image
        contentView.isHidden = false
        picker.dismiss(animated: true)
    }
}
