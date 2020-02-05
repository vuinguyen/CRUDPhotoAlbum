//
//  CustomCollectionViewController.swift
//  CRUDPhotoAlbum
//
//  Created by Vui Nguyen on 1/31/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var pageControl: UIPageControl!

  @IBOutlet var cameraButton: UIBarButtonItem!

  @IBAction func displayPhotoGrid(_ sender: Any) {
    print("selected display photo grid")
  }


  @IBAction func deletePhoto(_ sender: Any) {
    print("delete this photo!")
  }


  @IBAction func pickPhotoFromCamera(_ sender: Any) {
    print("display camera function")
    pickImage(isSourceAlbum: false)
  }


  @IBAction func pickPhotoFromAlbum(_ sender: Any) {
    print("display photos app")
    pickImage(isSourceAlbum: true)
  }
  
  let reuseID = "photoCell"

  lazy var photos: [UIImage] = { [weak self] in
    var images: [UIImage] = []
    ["schnoodle1", "schnoodle2", "schnoodle3", "schnoodle4"].forEach { imageName in
      if let image = UIImage(named: imageName) {
        images.append(image)
      }
    }

    return images
    }()

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureCollectionView()
    configurePageControl()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
  }

  private func configurePageControl() {
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

  private func pickImage(isSourceAlbum: Bool) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    imagePickerController.sourceType = isSourceAlbum ? .photoLibrary : .camera
    present(imagePickerController, animated: true, completion: nil)
  }
}

extension CustomCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CustomCollectionViewCell
    cell.image = photos[indexPath.row]

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
