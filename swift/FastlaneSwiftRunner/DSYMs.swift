//
//  DSMYManager.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/03.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

struct DSYMs {
    
    static func refreshAll(_ minVersion: String = "1.2.5") {
        downloadDsyms(apiKeyPath: .userDefined(ENV.fastlane_itc_apikey_path.value), username: appleID, appIdentifier: appIdentifier, teamId: .userDefined(ENV.fastlane_itc_team_id.value), minVersion: .userDefined(minVersion))
        verbose(message: "DSYM_PATHS: \(laneContext().DSYM_PATHS)")
        laneContext().DSYM_PATHS.forEach({ uploadSymbolsToCrashlytics(dsymPath: $0) })
        cleanBuildArtifacts()
    }
    
    static func upload(_ selectVersion: String?) {
        downloadDsyms(apiKeyPath: .userDefined(ENV.fastlane_itc_apikey_path.value), username: appleID, appIdentifier: appIdentifier, teamId: .userDefined(ENV.fastlane_itc_team_id.value), version: .userDefined(selectVersion))
        laneContext().DSYM_PATHS.forEach({ uploadSymbolsToCrashlytics(dsymPath: $0) })
        cleanBuildArtifacts()
    }
}

