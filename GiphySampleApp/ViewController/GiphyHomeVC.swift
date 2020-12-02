//
//  GiphyHomeVC.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import UIKit
import GiphyCoreSDK
import SDWebImage
import GiphyUISDK

class GiphyHomeVC: UITableViewController, UISearchResultsUpdating, TableViewCellDelegate {

    // MARK: Properties
    let viewModel = HomeViewViewModel()
    var favouriteViewModel = FavouriteViewViewModel()
    var resultSearchController = UISearchController()
    fileprivate let loadingIndicator = UIActivityIndicatorView(style: .large)
 
    // MARK: UISceneSession Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.loadingIndicator.stopAnimating()
                self?.favouriteViewModel.fetchLocalDataDB()
            }
        }

        resultSearchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.searchBar.sizeToFit()
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.placeholder = NSLocalizedString("Search GIFs", comment: "")
            searchController.searchResultsUpdater = self
            searchController.definesPresentationContext = false
            return searchController
        })()
        
        self.resultSearchController.searchBar.delegate = self
        
        loadingIndicator.color = UIColor.lightGray
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        loadingIndicator.startAnimating()
        self.viewModel.currentTrendingPageOffset = 0
        self.viewModel.getTrendingGiphyPagingList(currentTrendingPageOffset: self.viewModel.currentTrendingPageOffset)
    }
    
    // object to update the search results for a specified controller.
    func updateSearchResults(for searchController: UISearchController) {
       
        if !searchController.isActive {
            tableView.reloadData()
        }
        
        if(searchController.searchBar.text!.count>0)
        {
            loadingIndicator.startAnimating()
            self.viewModel.getSearchPage(searchTerm: searchController.searchBar.text!, offset:self.viewModel.currentTrendingPageOffset)
        }
    }
    
    // This method is used to add/save and delete giphy into and from local DB
    func addGiphyToFavourite(delegatedFrom cell: GiphyHomeTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let isFavTuple = IsDataIsFavourited(title: self.viewModel.giphyImages[indexPath.row].title)
            
            if(isFavTuple.isFavourited){
                self.favouriteViewModel.deleteFavouriteSavedGiphy(row: isFavTuple.row)
                tableView.reloadData()
            }
            else{
                self.viewModel.saveGiphyInLocalDB(row: indexPath.row)
            }
            
        }
    }
}

// MARK: Extension : Giphy table view datasource
extension GiphyHomeVC {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.giphyImages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GiphyHomeTableViewCell
        
        cell.delegate = self
        
        if(self.viewModel.giphyImages.count>0){
            
            let listOfImages = self.viewModel.giphyImages[indexPath.row]
            let imageID = listOfImages.id
            let imageURL = "https://media1.giphy.com/media/\(imageID)/200.gif"
            let url = URL(string: imageURL)!
            
            cell.giphyImageView.sd_setImage(with: url)
            cell.giphyTitleText.text = listOfImages.title
            
            let isFavTuple = IsDataIsFavourited(title: listOfImages.title)
            if(isFavTuple.isFavourited){
                cell.addFavouriteButton.setImageTintColor(UIColor.green)
            }
            else{
                cell.addFavouriteButton.setImageTintColor(UIColor.black)
            }
            
            return cell
        }
        
        return cell;
    }
    
    func IsDataIsFavourited(title: String)->(isFavourited: Bool, row: Int)
    {
        let countForSavedData = favouriteViewModel.giphySavedData.count
        
        if(countForSavedData > 0)
        {
            for number in 0..<countForSavedData {
                
                if(favouriteViewModel.giphySavedData[number].title.isEqual(title)) {
                    return (true, number)
                }
            }
            
            return (false, 1)
        }
        
        return (false, 1)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0;
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let height = scrollView.frame.size.height
       let contentYoffset = scrollView.contentOffset.y
       let distanceFromBottom = scrollView.contentSize.height - contentYoffset
       if distanceFromBottom < height {
        
            if  (resultSearchController.isActive) {
                self.viewModel.getSearchPage(searchTerm: resultSearchController.searchBar.text!, offset:self.viewModel.currentTrendingPageOffset)
            }
            else{
                self.viewModel.getTrendingGiphyPagingList(currentTrendingPageOffset: self.viewModel.currentTrendingPageOffset)
            }
        }
    }
}

// MARK: extension to getting Searchbar action for Serach button of keyboard
extension GiphyHomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resultSearchController.isActive = false
    }
}

extension UIButton{

    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}
