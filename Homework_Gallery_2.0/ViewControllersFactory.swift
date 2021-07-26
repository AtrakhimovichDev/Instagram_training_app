//
//  ViewControllersFactory.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 22.07.21.
//

import UIKit

class ViewControllersFactory {
    
    static func createGalleryViewController(identifier: String, user: User) -> GalleryViewController {
        let controller = ViewControllersFactory.createViewController(identifier: identifier)
        if let galleryVC = controller as? GalleryViewController {
            galleryVC.user = user
            return galleryVC
        } else {
            return GalleryViewController()
        }
    }
    
    static func createFriendsViewController(identifier: String, user: User) -> FriendsViewController {
        let controller = ViewControllersFactory.createViewController(identifier: identifier)
        if let friendsVC = controller as? FriendsViewController {
            friendsVC.user = user
            return friendsVC
        } else {
            return FriendsViewController()
        }
    }
    
    static func createNewPhotoViewController(identifier: String, user: User) -> NewPhotoViewController {
        let controller = ViewControllersFactory.createViewController(identifier: identifier)
        if let newPhotoVC = controller as? NewPhotoViewController {
            newPhotoVC.user = user
            return newPhotoVC
        } else {
            return NewPhotoViewController()
        }
    }
    
    static func createProfileViewController(identifier: String, user: User) -> ProfileViewController {
        let controller = ViewControllersFactory.createViewController(identifier: identifier)
        if let profileVC = controller as? ProfileViewController {
            profileVC.user = user
            return profileVC
        } else {
            return ProfileViewController()
        }
    }
    
    private static func createViewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: identifier)
        return controller
    }
}
