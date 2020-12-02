//
//  GiphyFavouriteCollectionViewCell.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func removeGiphyFromFavourite(delegatedFrom cell: GiphyFavouriteCollectionViewCell)
}

class GiphyFavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var giphyTitleText: UILabel!
    @IBOutlet weak var giphyImageView: UIImageView!
    weak var delegate: CollectionViewCellDelegate?
  
    @IBAction func removeFavouriteGiphyAction(_ sender: Any) {
        delegate?.removeGiphyFromFavourite(delegatedFrom: self)
    }
}
