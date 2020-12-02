//
//  GiphyHomeTableViewCell.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import UIKit

protocol TableViewCellDelegate: class {
    func addGiphyToFavourite(delegatedFrom cell: GiphyHomeTableViewCell)
}

class GiphyHomeTableViewCell: UITableViewCell {

    weak var delegate: TableViewCellDelegate?
    @IBOutlet weak var giphyTitleText: UILabel!
    @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var addFavouriteButton: UIButton!
    
    @IBAction func addToFavouriteButtonAction(_ sender: Any) {
        delegate?.addGiphyToFavourite(delegatedFrom: self)
    }
}
