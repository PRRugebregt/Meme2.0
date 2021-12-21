//
//  TabBarViewController.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 20/12/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    let coreDataManager = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storedMemes = coreDataManager.fetchSavedMemes()
        for meme in storedMemes {
            let originalImage = UIImage(data: meme.originalImage!)
            let memedImage = UIImage(data: meme.memedImage!)
            let memeObject = MemeObject(originalImage: originalImage!, topText: meme.topText!, bottomText: meme.bottomText!, memedImage: memedImage!)
            appDelegate.memes.append(memeObject)
        }
        // Do any additional setup after loading the view.
    }

}
