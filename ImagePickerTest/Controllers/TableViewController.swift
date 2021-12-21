//
//  TableViewController.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 20/12/2021.
//

import UIKit

class TableViewController: UIViewController, ReloadData {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var sentImage = UIImage()
    var memes = [MemeObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addMeme))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ], for: .normal)
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.dequeueReusableCell(withIdentifier: "CustomCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
    }
    
    @objc func addMeme() {
        performSegue(withIdentifier: "toImagePicker", sender: self)
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.memes = self.appDelegate.memes
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let destination = segue.destination as! ShowImageViewController
            destination.sentImage = sentImage
        } else  if segue.identifier == "toImagePicker" {
            let destination = segue.destination as! MemeEditorViewController
            destination.delegate = self
        }
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sentImage = memes[indexPath.row].memedImage
        performSegue(withIdentifier: "showImage", sender: self)
    }
    
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        cell.losImagicos.image = memes[indexPath.row].memedImage
        cell.losLabelos.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        return cell
    }
}
