//
//  SplashViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

protocol SplashViewControllerDelegate: AnyObject {
    func appStart()
}

extension SplashViewControllerDelegate {
    func appStart() {}
}

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var viewModel: SplashViewModel!
    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure("Lütfen viewModel'ı inject ederek devam et!")
        }
        
        setupUI()
        addObservationListener()
        viewModel.start()
    }
    
    private func setupUI() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            welcomeLabel.text = "Merhaba"
        } else {
            welcomeLabel.text = "Hoş geldin"
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        welcomeLabel.font = UIFont.avenir(.Heavy, size: 36)
        welcomeLabel.textColor = .white
    }
    
    func inject(viewModel: SplashViewModel, delegate: SplashViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
}


// MARK: - ViewModel Listener
extension SplashViewController {
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
    
    private func handleClosureData(data: SplashViewModelImpl.ViewInteractivity) {
        switch data {
        case .appStart:
            delegate?.appStart()
        }
    }
}
