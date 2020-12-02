//
//  HomeViewViewModel.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import Foundation
import UIKit
import CoreData

public typealias ImageDownloadCompletionClosure = (_ responseData: GiphyResponseModel? ) -> Void

class HomeViewViewModel {
    
    // Properties Declaration
    
    var giphyImages = [GiphyImages]()
    var giphyImagesData = [GiphyImages]()
    let service = GiphyWebServices()
    var reloadTableViewClosure:(()-> Void)? = nil
    var giphyMainResponse = [GiphyResponseModel]()
    
    public var currentTrendingPageOffset: Int = 0
    
    
    public enum SwiftyGiphyAPIContentRating: String {
        case y = "y"
        case g = "g"
        case pg = "pg"
        case pg13 = "pg-13"
        case r = "r"
    }
}

// MARK: Extension : HomeView View Model
extension HomeViewViewModel{

     /*  //- Parameters:
           - limit: The limit of results to fetch
           - rating: The max rating for the gifs
           - offset: The paging offset
     */
    /// Get the currently trending gifs from Giphy
    func getTrendingGiphyPagingList(currentTrendingPageOffset: Int? = nil, limit: Int = 1000, rating: SwiftyGiphyAPIContentRating = .pg13)  {
        
        var params = [String : Any]()
        params["limit"] = limit
        params["rating"] = rating.rawValue
        
        if let currentOffset = currentTrendingPageOffset
        {
            params["offset"] = currentOffset
        }
        
        service.callGiphyWebService(params: params) { (response) in
            guard let res = response else{return}
            
            self.currentTrendingPageOffset = (res.paginationData.offset) + (res.paginationData.count)
            
            self.giphyImages = res.gifsData
            self.reloadTableViewClosure?()
        }
    }
    
    
    /* //- Parameters:
        - searchTerm: The phrase to use to search Giphy
        - limit: The limit of results to fetch
        - rating: The max rating for the gifs
        - offset: The paging offset
     */
    /// Get the results for a search from Giphy
    func getSearchPage(searchTerm: String, offset: Int? = nil, limit: Int = 1000, rating: SwiftyGiphyAPIContentRating = .pg13){
        
        var params = [String : Any]()
        
        params["q"] = searchTerm
        params["limit"] = limit
        params["rating"] = rating.rawValue
        
        if let currentOffset = offset
        {
            params["offset"] = currentOffset
        }
        
        service.callSearchWebService(params: params) { (response) in
            guard let res = response else{return}
            self.currentTrendingPageOffset = (res.paginationData.offset) + (res.paginationData.count)
            self.giphyImages = res.gifsData
            self.reloadTableViewClosure?()
        }
    }
    
    // This method is used to save Giphy item into local DB for showing favourite items
    func saveGiphyInLocalDB(row:Int)
    {
        let gifImageData = giphyImages[row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "GiphyListData", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)

        let imageID = gifImageData.id
        let imageURL = "https://media1.giphy.com/media/\(imageID)/200.gif"

        newUser.setValue(imageURL, forKey: "url")
        newUser.setValue(gifImageData.title, forKey: "title")

        do {
            try context.save()
            self.reloadTableViewClosure?()

        } catch {
            print("Failed to saving")
        }
    }
}
