//
//  MovieListViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation
import Alamofire

protocol MovieListViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<MovieListViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    
    /// ViewController' daki tableView'in row sayısını döner.
    /// - Returns: Int
    func getNumberOfRowsInSection() -> Int
    
    /// ViewController' daki tableView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
    /// - Returns: Movie datası
    func getMovieForCell(at indexPath: IndexPath) -> Movie?
    
    func downloadMovies(search:String)

}

final class MovieListViewModelImpl: MovieListViewModel {
    
    
    //verileri getirme
    var searchResult : Search?

    func downloadMovies(search: String) {
        //http://www.omdbapi.com/?s=thor&page1&apikey=9f5de465"
            AF.request("https://www.omdbapi.com/?s=\(search)&plot=full&page=\(1)&apikey=9f5de465",method: .get).response { response in
                if let data = response.data {
                    do{
                        let result = try JSONDecoder().decode(Search.self, from: data)
                        self.searchResult = result
                        self.start()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }

    
    
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
    func start() {
        self.stateClosure?(.success(.updateMovieList))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieListViewModelImpl {
    enum ViewInteractivity {
        case updateMovieList
    }
}


// MARK: TableView DataSource
extension MovieListViewModelImpl {
    func getNumberOfRowsInSection() -> Int {
        return self.searchResult?.movies?.count ?? 0
       
    }
    
    func getMovieForCell(at indexPath: IndexPath) -> Movie? {
        guard let movie = self.searchResult?.movies?[indexPath.row] else { return nil }
        return movie
    }
}