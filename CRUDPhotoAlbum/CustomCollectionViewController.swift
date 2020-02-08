//
//  CustomCollectionViewController.swift
//  CRUDPhotoAlbum
//
//  Created by Vui Nguyen on 1/31/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController, UINavigationControllerDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var pageControl: UIPageControl!

  @IBOutlet var gridButton: UIBarButtonItem!
  @IBOutlet var cameraButton: UIBarButtonItem!
  @IBOutlet var trashButton: UIBarButtonItem!
  
  @IBAction func displayPhotoGrid(_ sender: Any) {
    print("selected display photo grid")
    performSegue(withIdentifier: "displayGrid", sender: nil)
  }


  @IBAction func deletePhoto(_ sender: Any) {
    print("delete this photo!")
    let destroyAction = UIAlertAction(title: "Delete",
                                      style: .destructive) { (action) in
                                      self.deleteImage()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let alert = UIAlertController(title: "Delete Picture?", message: "",
                                  preferredStyle: .actionSheet)
    alert.addAction(destroyAction)
    alert.addAction(cancelAction)

    // On iPad, action sheets must be presented from a popover.
    alert.popoverPresentationController?.barButtonItem = trashButton

    self.present(alert, animated: true, completion: nil)
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
  var deletedIndexPath: IndexPath?

 // var photos: [UIImage] = []

  lazy var photos: [UIImage] = { [weak self] in
    var images: [UIImage] = []
    ["schnoodle1", "schnoodle2", "schnoodle3", "schnoodle4"].forEach { imageName in
      if let image = UIImage(named: imageName) {
        images.append(image)
      }
    }

    return images
    }()


   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "displayGrid" {
      print("lets segue to the grid")
      let albumViewController = segue.destination as! AlbumCollectionViewController
      albumViewController.photos = photos
    }
   }

  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureCollectionView()
    configurePageControl()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureButtons()
  }

  private func configureButtons() {
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    trashButton.isEnabled = photos.count > 0 ? true : false
    gridButton.isEnabled = photos.count > 0 ? true: false
  }

  private func configurePageControl() {
    pageControl.currentPageIndicatorTintColor = .red
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.numberOfPages = photos.count

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
    print("current page is \(pageControl.currentPage)")
  }

  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
  }

  private func pickImage(isSourceAlbum: Bool) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = isSourceAlbum ? .photoLibrary : .camera
    present(imagePickerController, animated: true, completion: nil)
  }

  private func addImage(image: UIImage) {
    var currentPageIndex = IndexPath(row: 0, section: 0)

    if ((pageControl?.currentPage) != nil) {
      currentPageIndex = IndexPath(row: pageControl.currentPage, section: 0)
    }

    print("at page \(currentPageIndex)")
    // insert picture at that spot
    photos.insert(image, at: currentPageIndex.row)
    // refresh collection view
    collectionView.reloadData()

    // scroll to newly added item
    pageControl.numberOfPages = photos.count
    collectionView.scrollToItem(at: currentPageIndex, at: .centeredHorizontally, animated: true)

    pageControl.currentPage = currentPageIndex.row
  }

  private func deleteImage() {
    //let updatedPageIndex = pageControl.currentPage == photos.count ?
    // IndexPath(row: pageControl.currentPage-1, section: 0) :
    // IndexPath(row: pageControl.currentPage, section: 0)
    if ((pageControl?.currentPage) == nil) {
      print("no image to delete")
      return
    }

   // let currentPageIndex = IndexPath(row: pageControl.currentPage, section: 0)
    /*
    guard let currentPageIndex = deletedIndexPath else {
      return
    }
 */
    let currentPageIndex = IndexPath(row: pageControl.currentPage, section: 0)
    let updatedPageIndex = pageControl.currentPage == photos.count ?
     // currentPageIndex.formIndex(before: &currentPageIndex.item)   :
      IndexPath(row: (currentPageIndex.row - 1), section: currentPageIndex.section) :
    currentPageIndex

    print("at page \(currentPageIndex.row)")
    print("updated page \(updatedPageIndex.row)")
    // remove picture at that spot
    photos.remove(at: currentPageIndex.row)
    // refresh collection view
    collectionView.reloadData()

    // scroll to newly added item
    pageControl.numberOfPages = photos.count

    // I am not scrolling to the right spot if the updatedPageIndex has changed
//collectionView.scrollToItem(at: currentPageIndex, at: .centeredHorizontally, animated: true)
    collectionView.scrollToItem(at: updatedPageIndex, at: .centeredHorizontally, animated: true)

    // it is displaying the right dots if using updatedPageIndex
   // pageControl.currentPage = currentPageIndex.row
    pageControl.currentPage = updatedPageIndex.row

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

// MARK: UICollectionViewDelegate
extension CustomCollectionViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    configurePageControl()
  }

  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // when deleting a cell
    deletedIndexPath = indexPath
    configureButtons()
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // about to add a cell
    configureButtons()
  }
}

extension CustomCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width,
                  height: collectionView.frame.height)
  }
}

// MARK: ImagePickerControllerDelegate
extension CustomCollectionViewController: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    print("we got into imagepickercontroller code")
    //picker.dismiss(animated: false, completion: nil)
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      addImage(image: image)
    } else {
      let alert = UIAlertController(title: "Picture Selection Error", message: "Failed To Select Picture",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                    style: .default, handler: { _ in
        print("There was an error in selecting a picture")
      }))
      self.present(alert, animated: true, completion: nil)
    }

    picker.dismiss(animated: true, completion: nil)
  }
}
