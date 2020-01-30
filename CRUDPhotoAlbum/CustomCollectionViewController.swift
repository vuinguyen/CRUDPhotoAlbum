//
//  CustomCollectionViewController.swift
//  CRUDPhotoAlbum
//
//  Created by Adrian Bolinger on 1/30/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController {
    
    // page view controller
    // https://medium.com/@shaibalassiano/tutorial-horizontal-uicollectionview-with-paging-9421b479ee94
    
    let reuseId = "pictureCell"
    
    lazy var pictures: [UIImage] = { [weak self] in
        var images: [UIImage] = []
        ["schnoodle1", "schnoodle2", "schnoodle3"].forEach { imageName in
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        
        return images
    }()

    @IBOutlet var topView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        [topView, bottomView].forEach { $0?.backgroundColor = .white }
        // Do any additional setup after loading the view.
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        // register collection view cell: https://www.hackingwithswift.com/example-code/uikit/how-to-register-a-cell-for-uicollectionview-reuse
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        // TODO: figure out scroll direction
        
    }
}

extension CustomCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CustomCollectionViewCell
        cell.image = pictures[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CustomCollectionViewController: UICollectionViewDelegate {
    // may or may  not need something here
}

// MARK: - UIScrollViewDelegate
extension CustomCollectionViewController: UIScrollViewDelegate {
    // implement logic to stop scrolling once the cell is centered.
    
}

extension CustomCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // https://stackoverflow.com/questions/29986379/uicollectionview-custom-cell-to-fill-width-in-swift
        let frame = collectionView.frame
        return CGSize(width: frame.width,
                      height: frame.height)
    }
}
