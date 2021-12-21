//
//  ViewController.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 12/15/21.
//

import UIKit

protocol ReloadData {
    func reload()
}

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, MoveUIOfViewController {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    private var original : UIImage?
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    let coreDataManager = CoreDataManager()
    var delegate : ReloadData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meme Editor"
        //imageView.contentMode = .scaleAspectFit
        topTextField.delegate = self
        bottomTextField.delegate = bottomTextFieldDelegate
        bottomTextFieldDelegate.subscribeToNotification()
        bottomTextFieldDelegate.delegate = self
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -1, /// this will make it possible to have a strocke and foreground color
        ]
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Dissapearing")
        delegate?.reload()
    }

    func moveViewUp(by amount: CGFloat) {
        guard bottomTextField.isFirstResponder else { return }
        if self.bottomTextField.frame.origin.y > self.view.frame.height - amount {
            self.view.frame.origin.y = -amount
        }
    }
    
    func moveViewDown(by amount: CGFloat) {
        if self.view.frame.minY != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func generateMemedImage() -> UIImage {
        moveToView(toView: imageView)

        // Render view to an image
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: imageView.frame.size), afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        moveToView(toView: self.view)
        
        return memedImage
    }
    
    func moveToView(toView: UIView) {
        // adding text to imageview to include in meme picture
        // after memed image is created add it back to self.view
        topTextField.willMove(toSuperview: toView)
        bottomTextField.willMove(toSuperview: toView)
        toView.addSubview(topTextField)
        toView.addSubview(bottomTextField)
        topTextField.center = imageView.center
        topTextField.layer.position.y = imageView.frame.minY
        bottomTextField.center = imageView.center
        bottomTextField.layer.position.y = imageView.frame.maxY - bottomTextField.frame.size.height
    }
    
    func saveAndShareMemeImage(originalImage: UIImage) {
        let memedImage = generateMemedImage()
        let topText = topTextField.text!
        let bottomText = bottomTextField.text!
        let memeObject = MemeObject(originalImage: originalImage, topText: topText, bottomText: bottomText, memedImage: memedImage)
        saveToAppDelegateArray(memeObject)
        coreDataManager.createDataObject(model: memeObject)
        let activityView = UIActivityViewController(activityItems: [memeObject.memedImage], applicationActivities: [])
        self.present(activityView, animated: true, completion: nil)
    }
    
    func saveToAppDelegateArray(_ memeObject: MemeObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(memeObject)
    }

    @IBAction func pickAnImage(_ sender: Any) {
        openImagePicker(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePicker(source: .camera)
    }
    
    func openImagePicker(source: UIImagePickerController.SourceType) {
        if source == .camera {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                showAlert(title: "Oops", message: "It seems that the camera is not available")
                return
            }
        }
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = source
        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareItem(_ sender: Any) {
        guard original != nil else {
            let alert = UIAlertController(title: "Whoops", message: "You dont have an image to share yet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        saveAndShareMemeImage(originalImage: original!)
    }
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        original = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        topTextField.text = "TopText"
        bottomTextField.text = "BottomText"
        dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
