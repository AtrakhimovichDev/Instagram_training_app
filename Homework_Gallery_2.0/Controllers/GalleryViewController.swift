//
//  GalleryViewController.swift
//  Homework_Gallery_2.0
//
//  Created by Andrei Atrakhimovich on 17.07.21.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesArray = [UIImage]()
    
    var cellSize: CGSize {
        var minimumLineSpacing: CGFloat = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            minimumLineSpacing = flowLayout.minimumLineSpacing
        }
        let width = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imagesArray.append(UIImage(named: "image1")!)
        imagesArray.append(UIImage(named: "image2")!)
        imagesArray.append(UIImage(named: "image3")!)
        imagesArray.append(UIImage(named: "image4")!)
        imagesArray.append(UIImage(named: "image5")!)
    }

}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = imagesArray[indexPath.item]
        cell.setup()
        return cell
    }
    
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    
}
