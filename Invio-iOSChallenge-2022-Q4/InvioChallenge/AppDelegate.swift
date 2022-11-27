//
//  AppDelegate.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = SplashViewController(nibName: SplashViewController.className, bundle: nil)
        splashVC.inject(viewModel: SplashViewModelImpl(), delegate: self)
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: SplashViewControllerDelegate {
    func appStart() {
        let movieListVC = MovieListViewController(nibName: MovieListViewController.className, bundle: nil)
        let viewModel = MovieListViewModelImpl()
        movieListVC.inject(viewModel: viewModel)
        let viewC = UINavigationController(rootViewController: movieListVC)
        self.window?.rootViewController = viewC
    }
}
