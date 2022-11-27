//
//  MovieListTableViewCell.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit
import Kingfisher

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet weak var movieImdbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.cornerRadius = 12
    }
    
    func setupCell(movie: Movie) {
        movieNameLabel.text = movie.title
        movieYearLabel.text = movie.year
        movieTypeLabel.text = movie.type
        movieImdbLabel.text = "IMDB ID : \(movie.id)"
        
        //resim getirme işlemi
        if let url = URL(string: movie.poster ?? ""){
                DispatchQueue.main.async {
                    self.posterImageView.kf.setImage(with: url)
                }
            }
        }

    
    @IBAction func likeButtonTapped(_ sender: Any) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.likeButton.setImage(UIImage(named: "like-fill"), for: .normal)
        }
    }
}
