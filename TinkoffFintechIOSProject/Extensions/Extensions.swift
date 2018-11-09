//
//  Extensions.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 14/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

extension UserDefaults {
    func getTheme(forKey key: String) -> UIColor? {
        var theme: UIColor?
        if let themeData = data(forKey: key) {
            do {
                theme = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: themeData)
            } catch {
                theme = nil
            }

        }
        return theme
    }

    func setTheme(theme: UIColor, forKey key: String) {
        if let themeData = try? NSKeyedArchiver.archivedData(withRootObject: theme, requiringSecureCoding: false) {
            UserDefaults.standard.set(themeData, forKey: key)
        }
    }
}

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self + 1)))
    }
}
