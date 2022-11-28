//
//  MovieDetailViewController.swift
//  InvioChallenge
//
//  Created by Ahsen Bahtışen on 25.11.2022.
//

import UIKit

class MovieDetailViewController: BaseViewController {

    private var detailviewModel: MovieDetailViewModel!
    
    var detail: MovieDetail?
    
    
   
    var movieId: String = ""
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var moviePlotLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieWriterLabel: UILabel!
    @IBOutlet weak var movieActorsLabel: UILabel!
    @IBOutlet weak var movieCountryLabel: UILabel!
    @IBOutlet weak var movieBoxOfficeLabel: UILabel!
    
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var boxOfficeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.cornerRadius = 12
    }
    
    
    override func viewDidLoad() {
        
        //detail = detailviewModel.getMovieDetail(id: <#T##String#>)
        super.viewDidLoad()
        
        setupNavBar(title: "Title", leftIcon: "left-arrow", rightIcon: "like-empty", leftItemAction: #selector(backPage), rightItemAction: #selector(favoriteButton))
           
        setupView()
       
        
        movieYearLabel.text = movieId
        
        detailviewModel.start()
        detailviewModel.getMovieDetail(id: movieId)
        detail = detailviewModel.getMovieForDetail()
        movieActorsLabel.text = detail?.actors
        
        
    }
    
  
    
    private func setupView() {
      
        movieDurationLabel.font = .roboto(.Medium, size: 16)
        movieDurationLabel.textColor = .softBlack
        movieYearLabel.font = .roboto(.Medium, size: 16)
        movieYearLabel.textColor = .softBlack
        movieLanguageLabel.font = .roboto(.Medium, size: 16)
        movieLanguageLabel.textColor = .softBlack
        movieRatingLabel.font = .roboto(.Medium, size: 16)
        movieRatingLabel.textColor = .softBlack
        
        durationLabel.font = .roboto(.Regular, size: 12)
        durationLabel.textColor = .softBlue
        yearLabel.font = .roboto(.Regular, size: 12)
        yearLabel.textColor = .softBlue
        languageLabel.font = .roboto(.Regular, size: 12)
        languageLabel.textColor = .softBlue
        ratingLabel.font = .roboto(.Regular, size: 12)
        ratingLabel.textColor = .softBlue
        
        
        moviePlotLabel.font = .roboto(.Regular, size: 12)
        moviePlotLabel.textColor = .softBlack
        movieDirectorLabel.font = .roboto(.Regular, size: 12)
        movieDirectorLabel.textColor = .softBlack
        movieWriterLabel.font = .roboto(.Regular, size: 12)
        movieWriterLabel.textColor = .softBlack
        movieActorsLabel.font = .roboto(.Regular, size: 12)
        movieActorsLabel.textColor = .softBlack
        movieCountryLabel.font = .roboto(.Regular, size: 12)
        movieCountryLabel.textColor = .softBlack
        movieBoxOfficeLabel.font = .roboto(.Regular, size: 12)
        movieBoxOfficeLabel.textColor = .softBlack
        
        plotLabel.font = .roboto(.Medium, size: 16)
        plotLabel.textColor = .softBlack
        directorLabel.font = .roboto(.Medium, size: 16)
        directorLabel.textColor = .softBlack
        writerLabel.font = .roboto(.Medium, size: 16)
        writerLabel.textColor = .softBlack
        actorsLabel.font = .roboto(.Medium, size: 16)
        actorsLabel.textColor = .softBlack
        countryLabel.font = .roboto(.Medium, size: 16)
        countryLabel.textColor = .softBlack
        boxOfficeLabel.font = .roboto(.Medium, size: 16)
        boxOfficeLabel.textColor = .softBlack
        
    }
    
    @objc func favoriteButton(){
        print("core data")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "like-fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    
    @objc func backPage(){
        goBack()
    }

    func inject(detailviewModel: MovieDetailViewModel){
        self.detailviewModel = detailviewModel
    }

    

}


extension MovieDetailViewController {
    func addObservationListener() {
        self.detailviewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    private func handleClosureData(data: MovieDetailViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateMovieDetail:
            print("detay sayfası açıldı")
        }
    }
    
}
