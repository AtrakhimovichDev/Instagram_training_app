//
//  CustomToolbar.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 21.07.21.
//

import UIKit

class CustomToolbar: UIToolbar {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var searchFriendsButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIBarButtonItem!
    @IBOutlet weak var likesButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!

    var homeButtonAction = {}
    var searchFriendsButtonAction = {}
    var addImageButtonAction = {}
    var profileButtonAction = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        Bundle(for: CustomToolbar.self).loadNibNamed(String(describing: CustomToolbar.self), owner: self, options: nil)
        self.layer.masksToBounds = true
        #if TARGET_INTERFACE_BUILDER
        contentView.frame = self.bounds
        self.addSubview(contentView)
        #else
        contentView.fixInContainer(self)
        #endif
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        homeButtonAction()
    }

    @IBAction func searchFriendsButtonPressed(_ sender: Any) {
        searchFriendsButtonAction()
    }

    @IBAction func addImageButtonPressed(_ sender: Any) {
        addImageButtonAction()
    }

    @IBAction func likesButtonPressed(_ sender: Any) {
    }

    @IBAction func profileButtonPressed(_ sender: Any) {
        profileButtonAction()
    }

}
