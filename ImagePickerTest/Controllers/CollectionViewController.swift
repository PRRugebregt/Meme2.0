//
//  CollectionViewController.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 20/12/2021.
//

import UIKit

class CollectionViewController: UIViewController, ReloadData {
    
    var memes = [MemeObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var shownImage = UIImage()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.title = "Collection"
        
        let itemSize = (view.frame.size.width - 18) / 4
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.itemSize = CGSize (width: itemSize, height: itemSize)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addMeme))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        collectionView.reloadData()
        print(memes.count)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionToShowImage" {
            let destination = segue.destination as! ShowImageViewController
            destination.sentImage = shownImage
        } else if segue.identifier == "collectionToImagePicker" {
            let destination = segue.destination as! MemeEditorViewController
            destination.delegate = self
        }
    }
    
    func reload() {
        memes = appDelegate.memes
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func addMeme() {
        performSegue(withIdentifier: "collectionToImagePicker", sender: self)
    }
    
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = memes[indexPath.row].memedImage
        shownImage = image
        performSegue(withIdentifier: "collectionToShowImage", sender: self)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.layoutIfNeeded()
        return cell
    }
}
