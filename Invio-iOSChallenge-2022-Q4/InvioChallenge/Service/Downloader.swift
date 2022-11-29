//
//  Downloader.swift
//  InvioChallenge
//
//  Created by Ahsen Bahtışen on 26.11.2022.
//

import Foundation
import Alamofire

class Downloader{
    

    var searchResult : Search?
    func getMovies(search: String) {
        
            AF.request("https://www.omdbapi.com/?s=\(search)&plot=full&page=\(1)&apikey=9f5de465",method: .get).response { response in
                if let data = response.data {
                    do{
                        let result = try JSONDecoder().decode(Search.self, from: data)
                        self.searchResult = result
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }
}
