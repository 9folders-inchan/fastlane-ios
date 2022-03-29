//
//  Options.swift
//  FastlaneRunner
//
//  Created by inchan on 2021/08/27.
//  Copyright © 2021 Joshua Liebowitz. All rights reserved.
//

import Foundation

typealias Options = [String: String]
extension Options {
    func value(key: OptionKey) -> String? {
        return self[key.rawValue]
    }
}

enum OptionKey: String {
    case versionNumber
    case buildNumber
    
    var rawValue: String {
        return "\(self)".uppercased()
    }
}
