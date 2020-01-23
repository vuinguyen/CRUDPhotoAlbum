//
//  ViewController.swift
//  CRUDPhotoAlbum
//
//  Created by Vui Nguyen on 1/20/20.
//  Copyright © 2020 SunfishEmpire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var middleView: UIView!
  var images = [UIImage]()
  var photos = ["schnoodle1", "schnoodle2", "schnoodle3", "schnoodle4"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    loadImages()
    if images.count == 0 {
      print("there are no pictures!")
      return
    }

    for i in 0..<images.count {
        let imageView = UIImageView()
        let x = middleView.frame.size.width * CGFloat(i)
        //imageView.center = middleView.center
        imageView.frame = CGRect(x: x, y: 0, width: middleView.frame.width, height: middleView.frame.height)
     // imageView.frame.height = middleView.frame.height
     // imageView.frame.width = middleView.frame.width


        imageView.contentMode = .scaleAspectFit
      //imageView.contentMode = .center

        imageView.image = images[i]

      scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)

      //imageView.center = middleView.center
      /*
        imageView.contentMode = .center;
        if (imageView.bounds.size.width > (images[i]).size.width && imageView.bounds.size.height > (images[i]).size.height) {
          imageView.contentMode = .scaleAspectFit;
        }
 */
        scrollView.addSubview(imageView)
    }
    
  }

  func loadImages() {
    for i in 0..<photos.count {
      if let image = UIImage(named: photos[i]) {
        images.append(image)
      }
    }
  }

}

