//
//  String+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 29.10.2023.
//

import Foundation

extension String {
    func truncate(to length: Int) -> String {
        guard count > length else {
            return self
        }
        let index = self.index(self.startIndex, offsetBy: length)
        return String(self[..<index])
    }
}
