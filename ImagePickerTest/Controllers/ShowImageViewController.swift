//
//  ShowImageViewController.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 20/12/2021.
//

import UIKit

class ShowImageViewController: UIViewController {
    
    var sentImage : UIImage?
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = sentImage
        // Do any additional setup after loading the view.
    }

}
