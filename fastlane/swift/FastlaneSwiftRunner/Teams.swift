//
//  Teams.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/08.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation


/*
 * teams plugin의 facts 타입값이 잘못되어 재정의함.
 */
fileprivate func _teams(title: String,
                        message: String,
                        facts: [[String: String]],
                        teamsUrl: String,
                        themeColor: String = "0078D7") {
let titleArg = RubyCommand.Argument(name: "title", value: title, type: nil)
let messageArg = RubyCommand.Argument(name: "message", value: message, type: nil)
let factsArg = RubyCommand.Argument(name: "facts", value: facts, type: nil)
let teamsUrlArg = RubyCommand.Argument(name: "teams_url", value: teamsUrl, type: nil)
let themeColorArg = RubyCommand.Argument(name: "theme_color", value: themeColor, type: nil)
let array: [RubyCommand.Argument?] = [titleArg,
messageArg,
factsArg,
teamsUrlArg,
themeColorArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "teams", className: nil, args: args)
  _ = runner.executeCommand(command)
}

struct Teams {
    let title: String
    let message: String
    let facts: [[String: String]]
    let teamsUrl = "https://9folders.webhook.office.com/webhookb2/56763729-830a-456d-8f3b-b8c9b51f836a@04cb3f5c-4ca6-48d1-bac2-b6ad9ba82800/IncomingWebhook/7131f00095d94ace956e44d0afe9de8c/d19c53d0-8540-4e5c-b393-e5ccdf3a1dbe"
    let themeColor = "0078D7"
    
    func send() {
        
        let versionString = (laneContext().VERSION_NUMBER.isEmpty == false && laneContext().BUILD_NUMBER.isEmpty == false) ? " v\(laneContext().VERSION_NUMBER)(\(laneContext().BUILD_NUMBER))" : ""
        let titlePrefix = "[iOS] Re:Work" + versionString
        let t = "\(titlePrefix) - \(title)"
        _teams(title: t, message: message, facts: facts, teamsUrl: teamsUrl, themeColor: themeColor)
    }
}
