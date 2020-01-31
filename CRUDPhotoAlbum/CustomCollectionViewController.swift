//
//  CustomCollectionViewController.swift
//  CRUDPhotoAlbum
//
//  Created by Adrian Bolinger on 1/30/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var pageControl: UIPageControl!

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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        [topView, bottomView].forEach { $0?.backgroundColor = .white }
        // Do any additional setup after loading the view.
        configureCollectionView()
        configurePageControl()
    }
    
    private func configurePageControl() {
        // whether it's hidden is determined by whe
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        
        // this gets the visible cell
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        // then we get a CGPoint for the center of it
        let visiblePoint = CGPoint(x: visibleRect.midX,
                                   y: visibleRect.midY)
        // then we get the indexPath for whatever the visiblePoint is...
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pageControl.currentPage = indexPath.row
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        configurePageControl()
    }
}

extension CustomCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width,
                      height: collectionView.frame.height)
    }
}
