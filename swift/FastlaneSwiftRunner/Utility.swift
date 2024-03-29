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
    case project = "xcproject"
    case workspace = "xcworkspace"
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
    
    var LATEST_VERSION: String {
        return self["LATEST_VERSION"] as? String ?? ""
    }
    
    var LATEST_BUILD_NUMBER: String {
        let key = "LATEST_BUILD_NUMBER"
        if let value = self.filter({ $0.key == key }).map({ $0 }).first {
            return "\(value)"
        }
        return ""
    }
    
    var LATEST_TESTFLIGHT_VERSION: String {
        return self["LATEST_TESTFLIGHT_VERSION"] as? String ?? ""
    }

    var LATEST_TESTFLIGHT_BUILD_NUMBER: String {
        let key = "LATEST_TESTFLIGHT_BUILD_NUMBER"
        if let value = self.filter({ $0.key == key }).map({ $0 }).first {
            return "\(value)"
        }
        return ""
    }

    var DSYM_PATHS: [String] {
        return self["DSYM_PATHS"] as? [String] ?? []
    }
    
    var DSYM_OUTPUT_PATH: String {
        return self["DSYM_OUTPUT_PATH"] as? String ?? ""
    }

    var APPBOX_SHARE_URL: String {
        return self["APPBOX_SHARE_URL"] as? String ?? ""
    }
    
    var GIT_BRANCH_ENV_VARS: String {
        return self["GIT_BRANCH_ENV_VARS"] as? String ?? ""
    }
    
    func printAll(_ tag: String? = nil, prefix: String = "LaneContext printAll") {
        var text = "\(self.description)"
        if let tag = tag, tag.isEmpty == false {
            text.insert(contentsOf:"<\(tag)>: ", at: text.startIndex)
        }

        text.insert(contentsOf:"\(prefix) ", at: text.startIndex)
        verbose(message: text)
    }
}




