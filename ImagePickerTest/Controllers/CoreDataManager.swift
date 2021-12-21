//
//  CoreDataManager.swift
//  ImagePickerTest
//
//  Created by Patrick Rugebregt on 21/12/2021.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetchSavedMemes() -> [Memes] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memes")
        var result = [Memes]()
        do {
            result = try context.fetch(fetchRequest) as! [Memes]
        } catch {
            print(error)
        }
        return result
    }
    
    func createDataObject(model: MemeObject) {
        let savedObject = Memes(context: context)
        let encodedMemedImage = model.memedImage.jpegData(compressionQuality: 1)
        let encodedOriginalImage = model.originalImage.jpegData(compressionQuality: 1)
        savedObject.memedImage = encodedMemedImage
        savedObject.originalImage = encodedOriginalImage
        savedObject.topText = model.topText
        savedObject.bottomText = model.bottomText
        save()
    }
    
}
