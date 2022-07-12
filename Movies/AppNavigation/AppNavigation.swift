//
//  AppNavigation.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

final class AppNavigation: UINavigationController {
    
    init() {
        let presenter = MainViewPresenter()
        let mainVC = MainViewController(with: presenter)
        super.init(rootViewController: mainVC)
        
        navigationBar.prefersLargeTitles = true
        mainVC.title = "Movies"
        mainVC.appNavigation = self
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
        
    func goToDetailView(with film: Film) {
        let presenter = DetailViewPresenter(with: film)
        let detailViewController = DetailViewController(with: presenter)
        detailViewController.title = film.title
        
        pushViewController(detailViewController, animated: true)
    }
    
}
