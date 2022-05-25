//
//  OptionType.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/03.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

//MARK: - Option Protocol

protocol OptionTypeProtocol: RawRepresentable, CaseIterable, Codable where RawValue == String {
    // identifier
    static var key: String { get }
    // initailizer
    init?(withOptions options: Options?)
    
    func asFact() -> [String: String];
}

extension OptionTypeProtocol {

    static var key: String { return String(describing: self).lowercased() }
    
    init?(withOptions options: Options?) {
        let value = options?[Self.key]
        if let element = Self.allCases
            .compactMap({ $0 })
            .filter({ "\($0)".lowercased() == value?.lowercased() })
            .first {
            self = element
        }
        else {
            return nil
        }
    }
    
    func asFact() -> [String: String] {
        return ["name": Self.key, "value": "\(self)"]
    }
}

enum Build_Configuration: String, OptionTypeProtocol {
    case Release, Debug
}

// Method used to export the archive. Valid values are: app-store, ad-hoc, package, enterprise, development, developer-id
enum Build_Export_Method: String, OptionTypeProtocol, Equatable {
    case appstore
    case adhoc
    case enterprise
    case development
    
    var rawValue: String {
        switch self {
        case .appstore: return "app-store"
        case .adhoc: return "ad-hoc"
        case .enterprise: return "enterprise"
        case .development: return "development"
        }
    }
    
    var nativeValue: String {
        return "\(self)"
    }
}

enum Deploy_Mode: String, OptionTypeProtocol {
    case appstore, testflight, uploadOnly, adhoc, inhouse, development, buildOnly

    public var name: String {
        switch self {
        case .appstore: return "Appstore"
        case .testflight: return "Testflgiht"
        case .uploadOnly: return "오직 업로드만"
        case .adhoc: return "Ad-hoc"
        case .inhouse: return "In-Houser"
        case .development: return "Development"
        default: return "오직 빌드만"
        }
    }
    
    var exportMethod: Build_Export_Method {
        switch self {
        case .appstore, .testflight, .uploadOnly: return .appstore
        case .adhoc: return .adhoc
        case .inhouse: return .enterprise
        default: return .development
        }
    }
    
    var iCloudContainerEnvironment: iCloudContainerEnvironmentType {
        switch self {
        case .development:
            return .Development
        default:
            return .Production
        }
    }
    
    var exportOptions: [String: Any] {
        return ["iCloudContainerEnvironment": iCloudContainerEnvironment.rawValue]
    }
}

enum DSYM_Upload_Mode: String, OptionTypeProtocol {
    
    case latest // App store connect에 올라간 마지막 버전
    case live   // App Store에 게시된 버전
    case all    // 전체
    case none
    
    var stringValue: String? {
        switch self {
        case .latest, .live: return self.rawValue
        default: return nil
        }
    }
}



enum Bump_Type: String, OptionTypeProtocol {
    case patch // 1.0.0 -> 1.0.1
    case minor // 1.0.0 -> 1.1.0
    case major // 1.0.0 -> 2.0.0
    case build_number
}

typealias VersioningManualType = (version: String?, build_number: String?)

enum Versioning_Mode {
        
    case none
    // auto
    case bump(Bump_Type)
    // manual (set version, set build number)
    case manual(VersioningManualType)
    // Selection Choose
    case selection
    
    init?(withOptions options: Options?) {
        let version = options?["version"]
        let build_number = options?["build_number"]
        
        if let version = version, let build_number = build_number, version.count > 0, build_number.count > 0  {
            self = .manual((version: version, build_number: build_number))
        }
        else if let versioning_mode = options?["versioning_mode"]?.lowercased() {
            if versioning_mode == "selection" || versioning_mode == "selection_mode" {
                self = .selection
            }
            else if versioning_mode == "none" {
                self = .none
            }
            else if let type = Bump_Type(rawValue: versioning_mode) {
                self = .bump(type)
            }
            else {
               return nil
            }
        }
        else {
            return nil
        }
    }    
}

enum iCloudContainerEnvironmentType: String, OptionTypeProtocol {
    case Development, Production
}
