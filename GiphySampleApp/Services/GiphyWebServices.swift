//
//  GiphyWebServices.swift
//  GiphySampleApp
//
//  Created by Ajay on 01/12/20.
//

import Foundation

class GiphyWebServices
{
    let apiKey = "uRTtgtA0oXLdMO0TcxQJJfcoIL5UP1Ou"
    let giphyAPIBase: URL = URL(string: "https://api.giphy.com/v1/gifs/")!
    
    /// /// Get the currently trending gifs from Giphy
    func callGiphyWebService(params: [String:Any], completionHanlder: @escaping ImageDownloadCompletionClosure) {
        var postDict = params
        postDict["api_key"] = apiKey
 
        let request = self.createRequest(baseURL: giphyAPIBase, relativePath: "trending", method: "GET", params: postDict)

        self.sendRequest(request: request, completionHanlder: completionHanlder)
    }
    
    /// Get the results for a search from Giphy
    func callSearchWebService(params: [String:Any], completionHanlder: @escaping ImageDownloadCompletionClosure) {
        var postDict = params
        postDict["api_key"] = apiKey
 
        let request = self.createRequest(baseURL: giphyAPIBase, relativePath: "search", method: "GET", params: postDict)

        self.sendRequest(request: request, completionHanlder: completionHanlder)
    }
    
    //Send a request
    fileprivate func sendRequest(request: URLRequest, completionHanlder: @escaping ImageDownloadCompletionClosure)
    {
        let jsonDecoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in

                guard let data = data else {
                      return
                }

                do {
                  let json = try jsonDecoder.decode(GiphyResponseModel.self, from: data)
                    completionHanlder(json)
    
                } catch {
                    print(error)
                }

            }.resume()
    }
    
    /* //Create a request.
     
     - parameter relativePath:    The relative path for the request (relative to the Giphy API base)
     - parameter method: The method for the request
     - parameter json:   The object to serialize to JSON (Array or Dictionary)
     
     - returns: The generated request.
     */
    fileprivate func createRequest(baseURL: URL, relativePath:String, method:String, params: [String : Any]?) -> URLRequest
    {
        var request = URLRequest(url: URL(string: relativePath, relativeTo: baseURL)!)
        
        request.httpMethod = method
        
        if let localparams = params as [String : AnyObject]?
        {
            if method == "GET"
            {
                // GET params
                var queryItems = [URLQueryItem]()
                
                for (key, value) in localparams
                {
                    let stringValue = (value as? String) ?? String(describing: value)

                    queryItems.append(URLQueryItem(name: key, value: stringValue))
                }
                
                var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
                
                components.queryItems = queryItems
                
                request.url = components.url
            }
            else
            {
                // JSON params
                let jsonData = try? JSONSerialization.data(withJSONObject: localparams, options: JSONSerialization.WritingOptions())
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
}
