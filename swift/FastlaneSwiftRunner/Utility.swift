//
//  Utility.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/28.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

enum ENV: String, CaseIterable {
    // Apple 계정 정보
    case apple_id, team_id
    
    // 프로젝트 정보
    case app_identifier, app_extention_identifiers
    case project
    case workspace
    case scheme
    
    // Match 정보
    case match_password, match_git_url, match_git_basic_authorization
        
    // Upload 정보
    case fastlane_itc_team_id, fastlane_itc_name, fastlane_itc_apikey_path
}

extension ENV {
    
    var key: String {
        return self.rawValue.uppercased()
    }
    
    var value: String {
        if self == .app_extention_identifiers {
            return environmentVariable(get: .userDefined(key)).replacingOccurrences(of: "!", with: ", ")
        }
        return environmentVariable(get: .userDefined(key))
    }
    
    var listValue: [String] {
        return value.components(separatedBy: ", ")
    }
    
    static func printAll() {
        verbose(message: "\(environmentVariable())");
        let titles = Self.allCases.compactMap({ $0.key })
        let titleMaxLength = titles.max{ $0.count < $1.count }?.count ?? 0
        let text = Self.allCases
            .compactMap({ element in
                let title = element.key
                var space = ""
                while (title.count + space.count) != titleMaxLength {
                    space += " "
                }
                return "* [\(title)]\(space) : \(element.value)"
            })
            .compactMap({ $0 })
            .joined(separator: "\n")
        Self.print(text: text)
    }
    
    private static func print(text: String) {
        verbose(message: "* ### ENV All List ###")
        verbose(message: "\n\(text)")
        verbose(message: "* ####################")
    }
}


typealias LaneContextType = [String: Any]
extension Collection where Self == LaneContextType {
    
    var VERSION_NUMBER: String {
        return self["VERSION_NUMBER"] as? String ?? ""
    }

    var BUILD_NUMBER: String {
        return self["BUILD_NUMBER"] as? String ?? ""
    }
    
    var DSYM_PATHS: [String] {
        return self["DSYM_PATHS"] as? [String] ?? []
    }

    var APPBOX_SHARE_URL: String {
        return self["APPBOX_SHARE_URL"] as? String ?? ""
    }
        
    func printAll(_ tag: String? = nil) {
        var text = "\(self.description)"
        if let tag = tag, tag.isEmpty == false {
            text.insert(contentsOf:"<\(tag)>: ", at: text.startIndex)
        }
        verbose(message: text)
    }
}


