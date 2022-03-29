//
//  CodeSigning.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/25.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

struct CodeSigning {
    
    static func sync(withOptions options: Options?) {
        let type = options?.build_export_method.nativeValue ?? matchfile.type
        verbose(message: "*** -- start <SYNC> code signing (\(type))")
        match(type: type, readonly: .userDefined(true))
        verbose(message: "*** -- finish <SYNC> code signing ")
    }
    
    static func renew (withOptions options: Options?) {
        let type = options?.build_export_method.nativeValue ?? matchfile.type
        verbose(message: "*** -- start <Renew> code signing (\(type))")
        match(type: type, forceForNewDevices: .userDefined(true),forceForNewCertificates: .userDefined(true))
        verbose(message: "*** -- finish <Renew> code signing ")
    }
}
