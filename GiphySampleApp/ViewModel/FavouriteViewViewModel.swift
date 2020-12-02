//
//  FavouriteViewViewModel.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import Foundation
import UIKit
import CoreData


class FavouriteViewViewModel {
    
    var giphyImages = [GiphyImages]()
    var reloadCollectionViewClosure:(()-> Void)? = nil
    var giphySavedData: Array<AnyObject> = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// MARK: Extension : Favourite View Model
extension FavouriteViewViewModel{
    
    // This method is used to get or fetch saved data from local DB
    func fetchLocalDataDB()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GiphyListData")
        request.returnsObjectsAsFaults = false

        do {
            self.giphySavedData = try context.fetch(request)
            self.giphySavedData.reverse()
            self.reloadCollectionViewClosure?()
            
        } catch {
            print("Failed to fetch")
        }
    }
    
    // This method is used to delete the saved data from local DB
    func deleteFavouriteSavedGiphy(row:Int)
    {
        let objectToDelete: NSManagedObject = giphySavedData[row] as! NSManagedObject
        context.delete(objectToDelete)
        do{
            self.giphySavedData.remove(at: row)
            try context.save()
        }
        catch{
           print("error to save")
        }
        
        self.reloadCollectionViewClosure?()
    }
}
