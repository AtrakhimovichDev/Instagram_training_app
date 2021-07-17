//
//  CustomCollectionViewCell.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.07.21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CustomCollectionViewCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userImageIconFooter: UIImageView!
    @IBOutlet weak var userImageIconHeader: UIImageView!
    
    func setup() {
        userImageIconHeader.layer.cornerRadius = userImageIconHeader.frame.height / 2
        userImageIconFooter.layer.cornerRadius = userImageIconFooter.frame.height / 2
    }
}
