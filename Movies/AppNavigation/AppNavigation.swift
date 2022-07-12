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
        let mainVC = MainViewController()
        super.init(rootViewController: mainVC)
        
        navigationBar.prefersLargeTitles = true
        mainVC.appNavigation = self
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    func goToDetailView(with film: Film) {
        let detailViewController = DetailViewController(film: film)
        pushViewController(detailViewController, animated: true)
    }
    
}
