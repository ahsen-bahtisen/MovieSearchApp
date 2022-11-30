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
    
    var pageNumber = 1
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
        
        if searchField.text == ""{
            let alert = UIAlertController(title: "Warning!", message: "Please enter a movie name!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }else{
            viewModel.updateArray()
            pageNumber = 1
            viewModel.downloadMovies(search: searchField.text ?? "", number: pageNumber)

        }
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
        cell.setupCell(movie: movie[indexPath.row])
        
        cell.addFavori = { sender in
            if cell.likeButton.currentImage == UIImage(named: "like-fill"){
                cell.likeButton.setImage(UIImage(named: "like-empty"), for: .normal)
                self.favoriArr.removeAll(where: {$0 == movie[indexPath.row].id})
                UserDefaults.standard.set(self.favoriArr, forKey: "favorites")
                UserDefaults.standard.synchronize()
            }
            else{
               cell.likeButton.setImage(UIImage(named: "like-fill"), for: .normal)
                self.favoriArr.append(movie[indexPath.row].id)
                UserDefaults.standard.set(self.favoriArr, forKey: "favorites")
                UserDefaults.standard.synchronize()
            }
        }
        
        if favoriArr.contains(movie[indexPath.row].id) {
            cell.likeButton.setImage(UIImage(named: "like-fill"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "like-empty"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.getMovieDetails(at: indexPath)
        let comeId = viewModel.getMovieForCell(at: indexPath)
        let detailVC = MovieDetailViewController(nibName: MovieDetailViewController.className, bundle: nil)
        let movieDetailVM = MovieDetailViewModelImpl()
        detailVC.inject(detailviewModel: movieDetailVM)
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.movieId = comeId![indexPath.row].id
        
    }
    
    
    private func spinenFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !tableView.visibleCells.isEmpty{
            
            if ((tableView.contentOffset.y ) > (tableView.contentSize.height - 100 - tableView.frame.size.height )){
                
                if pageNumber != 100{
                    self.tableView.tableFooterView = spinenFooter()
                    pageNumber += 1
                    viewModel.downloadMovies(search: self.searchField.text!, number: pageNumber)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else{
                    self.tableView.tableFooterView = nil
                }
   
            }
        }

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
