//
//  Extension.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension DateFormatter {
    func stringDate(from stringDate: String, currentFormat: String, to format: String) -> String? {
        self.dateFormat = currentFormat
        guard let tempDate = self.date(from: stringDate) else { return nil }
        self.dateFormat = format
        return self.string(from: tempDate)
    }
}
