//
//  Versioning.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/08.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

struct Versioning {
    
    struct Version {
        
        static func set(_ versionNumber: String, target: String? = nil) {
            if let target = target {
                verbose(message: "*** -- versionNumber: \(versionNumber), target: \(target)")
            }
            incrementVersionNumberInXcodeproj ( versionNumber: .userDefined(versionNumber), xcodeproj: .userDefined(project), target: .userDefined(target ?? scheme) )
        }
        
        static func increment(_ bumpType: Bump_Type = .build_number) {
            incrementVersionNumberInXcodeproj ( bumpType: bumpType.rawValue, xcodeproj: .userDefined(project), target: .userDefined(scheme) )
        }
    }
    
    struct BuildNumber {
        
        static func set(_ buildNumber: String?, target: String? = nil) {
            if let target = target {
                verbose(message: "*** -- buildNumber: \(buildNumber ?? ""), target: \(target)")
            }
            incrementBuildNumberInXcodeproj ( buildNumber: .userDefined(buildNumber), xcodeproj: .userDefined(project), target: .userDefined(target ?? scheme) )
        }
        
        static func incremnet() {
            Self.set(nil)
        }
        
        static func initailize(_ initalValue: String = "1") {
            Versioning.Fetch.xcodeproj { version, buildNumber in
                let newBuild = String(format: "%02d", Int(initalValue) ?? 1)
                
                let versionSplits = version.split(separator: ".")                
                let newVersion = versionSplits
                    .map({ String(format: $0 == versionSplits.first ? "%d" : "%02d", Int($0) ?? 1) })
                    .joined()
            
                Self.set(newVersion.appending(newBuild))
            }
        }
    }

    
    struct Fetch {
        
        typealias Completion = (_ version: String, _ buildNumber: String) -> Void
        
        static func plist(_ completion: Completion?) {
            getVersionNumberFromPlist(xcodeproj: .userDefined(project), target: .userDefined(scheme))
            getBuildNumberFromPlist(xcodeproj: .userDefined(project), target: .userDefined(scheme))
            completion?(laneContext().VERSION_NUMBER, laneContext().BUILD_NUMBER)
        }
        
        static func xcodeproj(_ completion: Completion?) {
            getVersionNumberFromXcodeproj(xcodeproj: .userDefined(project), target: .userDefined(scheme))
            getBuildNumberFromXcodeproj(xcodeproj: .userDefined(project), target: .userDefined(scheme))
            completion?(laneContext().VERSION_NUMBER, laneContext().BUILD_NUMBER)
        }
        
        static func appstore(_ completion: Completion?) {
            //getAppStoreVersionNumber(bundleId: .userDefined(appIdentifier))
        }
    }
    
    struct SelectionMode: Choosable {
        
        enum Item: String, CaseIterable {
            case major, minor, patch, build_number, manual, none
            
            var title: String? {
                return self == .none ? nil : self.rawValue
            }
            
            var description: String? {
                switch self {
                case .major: return "v1.0.0(5) -> v2.0.0(1)"
                case .minor: return "v1.0.0(5) -> v1.1.0(1)"
                case .patch: return "v1.0.0(5) -> v1.0.1(1)"
                case .build_number: return "v1.0.0(5) -> v1.0.0(6)"
                default: return nil
                }
            }
            
            var orderNumber: String? {
                let allCases = Self.allCases.filter({ $0.title != nil })
                if let index = allCases.firstIndex(of: self) {
                    return "\(index)"
                }
                return nil
            }

            var info: (orderNumber: String, text: String)? {
                guard let orderNumber = orderNumber, var text = title else { return nil }
                if let desc = description {
                    text += ": \(desc)"
                }
                return (orderNumber, text)
            }
            
            var text: String? {
                guard let orderNumber = orderNumber, let title = title else { return nil }
                var text = "* \(orderNumber). \(title)"
                if let desc = description {
                    text += ": \(desc)"
                }
                return text
            }
        }
        
        static var title: String = "RUN VERSIONING SELECTION MODE"
        static var items: [String] = Self.Item.allCases.map({ $0.info?.text }).compactMap({ $0 })

        static func run(completion: (_ selectedItem: Item) -> Void) {
            
            println(message: "\(Self.title)")
            Self.runChoose { result in
                switch result {
                case .success(let index):
                    if index < Self.Item.allCases.count {
                        let selectedItem = Self.Item.allCases[index]
                        verbose(message: "success \(selectedItem)")
                        completion(selectedItem)
                    }
                    else {
                        verbose(message: "Retry1 ... ")
                        Self.run(completion: completion)
                    }
                case .failure(let error):
                    verbose(message: "Retry2 ... \(error.localizedDescription)")
                    Self.run(completion: completion)
                }
            }
        }
        
    }
}


// MARK: - Choosable

enum ChoosableError: Error {
    case unknow
    case needRetry
}

enum ChoosableResult {
    case success(_ index: Int)
    case failure(_ error: ChoosableError)
    
    init(_ index: Int) {
        self = .success(index)
    }
    
    init(_ error: ChoosableError) {
        self = .failure(error)
    }
}

protocol Choosable {
    
    typealias Error = ChoosableError
    typealias Result = ChoosableResult
    
    static var title: String { get }
    static var items: [String] { get }
    static func runChoose(completion: (_ result: Choosable.Result) -> ())
}

extension Choosable {
    private static var prefix: String {
        return "* "
    }
    
    static func runChoose(completion: (_ result: Choosable.Result) -> ()) {
        let prefix = Self.prefix
        let title = prefix + Self.title
        let items = Self.items
        let contents = items
            .map { content -> (index: Int, value: String) in
                let index = items.firstIndex(of: content)!
                return (index, content)
            }
            .map({ prefix + "\($0.index). " + $0.value }).joined(separator: "\n")
        
        let text = title + "\n" + contents
        let inputText = prompt(text: text)

        if let index = Int(inputText), index < items.count {
            completion(.success(index))
        }
        else {
            let filtered = items
                .map { str -> String in
                    if let index = str.firstIndex(of: ":") {
                        return String(str[str.startIndex..<index])
                    }
                    return str
                }
                .filter({ $0.contains(inputText) || $0.hasPrefix(inputText) || $0 == inputText })
                .first
            if let filtered = filtered, let index = items.firstIndex(of: filtered), index < items.count {
                completion(.success(index))
            }
            else {
                completion(.failure(.needRetry))
            }
        }
    }
}
