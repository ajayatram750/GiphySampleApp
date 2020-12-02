//
//  GiphyFavouriteVC.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import UIKit
import GiphyCoreSDK
import SDWebImage
import GiphyUISDK
import CoreData

class GiphyFavouriteVC: UICollectionViewController, CollectionViewCellDelegate {
  
    let viewModel = FavouriteViewViewModel()
    var noContentsLabel = UILabel()
    
    // MARK: UISceneSession Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noContentsLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 50))
        self.noContentsLabel.textAlignment = .center
        self.noContentsLabel.text = "No contents avalable!!"
        self.view.addSubview(self.noContentsLabel)
        
        self.viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchLocalDataDB()
        self.noContentsLabelShowOrHide()
    }
    
    //This method used to deleting favourite item from local DB
    func removeGiphyFromFavourite(delegatedFrom cell: GiphyFavouriteCollectionViewCell) {
        
        if let indexPath = collectionView.indexPath(for: cell) {
            self.viewModel.deleteFavouriteSavedGiphy(row: indexPath.row)
            self.noContentsLabelShowOrHide()
        }
    }
    
    func noContentsLabelShowOrHide()
    {
        if(self.viewModel.giphySavedData.count>0){
            noContentsLabel.isHidden = true
        }else{
            noContentsLabel.isHidden = false
        }
        
    }
}

// MARK: Extension : Giphy collection view datasource
extension GiphyFavouriteVC {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.giphySavedData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiphyFavouriteCollectionViewCell
    
        cell.delegate = self
        let data = self.viewModel.giphySavedData[indexPath.row]
        
        cell.giphyTitleText.text = data.title
        let url = URL(string: data.url)
        cell.giphyImageView.sd_setImage(with: url)
        
        return cell
    }
}
