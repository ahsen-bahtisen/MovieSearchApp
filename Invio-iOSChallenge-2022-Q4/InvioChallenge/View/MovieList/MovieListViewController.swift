//
//  MovieListViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MovieListViewModel!
    private var detailViewModel: MovieDetailViewModel!
    var movies: [Movie] = []
    var detailMovies: [MovieDetail] = []
    var favoriArr = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure("Lütfen viewModel'ı inject ederek devam et!")
        }
        
        setupView()
        setupTableView()
        addObservationListener()
        viewModel.start()
    }
    
    func inject(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupView() {
        topContentView.roundBottomCorners(radius: 20)
        searchContainerView.cornerRadius = 10
        searchField.font = .avenir(.Book, size: 16)
        searchField.textColor = .softBlack
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieListTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        tableView.separatorStyle = .none
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        viewModel.downloadMovies(search: searchField.text ?? "")
    }
}


// MARK: - TableView Delegate & DataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel.getMovieForCell(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.className, for: indexPath) as! MovieListTableViewCell
        cell.setupCell(movie: movie)
        
        cell.addFavori = { sender in
            if cell.likeButton.currentImage == UIImage(named: "like-fill"){
                cell.likeButton.setImage(UIImage(named: "like-empty"), for: .normal)
                self.favoriArr.removeAll(where: {$0 == movie.id})
                UserDefaults.standard.set(self.favoriArr, forKey: "favorites")
                UserDefaults.standard.synchronize()
            }
            else{
               cell.likeButton.setImage(UIImage(named: "like-fill"), for: .normal)
                self.favoriArr.append(movie.id)
                UserDefaults.standard.set(self.favoriArr, forKey: "favorites")
                UserDefaults.standard.synchronize()
            }
        }
        
        if favoriArr.contains(movie.id) {
            cell.likeButton.setImage(UIImage(named: "like-fill"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "like-empty"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let url = "http://www.omdbapi.com/?i=\(movies[indexPath.row].id)&apikey=9f5de465"
        let comeId = viewModel.getMovieForCell(at: indexPath)
        
        //print(comeId?.id)
        
        
        let detailVC = MovieDetailViewController(nibName: MovieDetailViewController.className, bundle: nil)
        
        detailVC.movieId = comeId?.id ?? ""
        
        let movieDetailVM = MovieDetailViewModelImpl()
        detailVC.inject(detailviewModel: movieDetailVM)
        navigationController?.pushViewController(detailVC, animated: true)
 
    }
}


// MARK: - ViewModel Listener
extension MovieListViewController {
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: MovieListViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateMovieList:
            self.tableView.reloadData()
        }
    }
}
