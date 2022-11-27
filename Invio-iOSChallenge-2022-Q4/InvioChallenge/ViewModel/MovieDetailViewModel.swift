//
//  MovieDetailViewModel.swift
//  InvioChallenge
//
//  Created by Ahsen Bahtışen on 25.11.2022.
//

import Foundation
import Alamofire


protocol MovieDetailViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<MovieDetailViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }

    func getMovieDetail(id: String)

}


final class MovieDetailViewModelImpl: MovieDetailViewModel {

    
    var detailResult: MovieDetail?
    
    func getMovieDetail(id: String) {
        
        //NotificationCenter.default.addObserver(self, selector: funcSelector!, name: .init(rawValue: "DetailTransfer"), object: nil)
    
        AF.request("http://www.omdbapi.com/?i=\(id)&apikey=9f5de465",method: .get).response { response in
            if let data = response.data {
                do{
                    let result = try JSONDecoder().decode(MovieDetail.self, from: data)
                    self.detailResult = result
                    self.start()
                    //print(result)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

    }

    

    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

    func start() {
        self.stateClosure?(.success(.updateMovieDetail))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieDetailViewModelImpl {
    enum ViewInteractivity {
        case updateMovieDetail
    }
}

