// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	
    // MARK: - Lifecycle

    func beforeAll(with lane: String) {
        // will start
        verbose(message: "will start")
    }
    
    func afterAll(with lane: String) {
        // did finish
        verbose(message: "did finish")
    }

    override func onError(currentLane: String, errorInfo: String, errorClass: String?, errorMessage: String?) {
        let message = """
*** -- ERROR
* currentLane   : \(currentLane)
* errorInfo     : \(errorInfo)
* errorClass    : \(errorClass ?? "<null>")
* errorMessage  : \(errorMessage ?? "<null>")
*** --
"""
        verbose(message:message)
        // TODO: error message to teams
    }
    
    
    // MARK: - test lanes
    func testLane(withOptions options: Options?) {
        let o = options ?? Options()
        readyLane(withOptions: o)
        versioningLane(withOptions: o)
        gitCommitAndPushLane(withOptions: o)
//        Versioning.Fetch.appstore { version, buildNumber in
//            verbose(message: "ver: \(version), bn: \(buildNumber)")
//        }
    }
    
    // MARK: - Deploy lane

    /* Alpha 배포 (개발용(Debug 환경) 빌드 -> AppBox 배포) **/
    func alphaLane(withOptions options: Options?) {
        desc("codeSigning -> versioning -> build -> upload(AppBox) -> sendToTeams")

        var o: Options = options ?? Options()
        o.deploy_mode = .development
        
        if o.use_upload_appbox == nil { o.use_upload_appbox = true }
        if o.use_git_push == nil { o.use_git_push = false }
        
        customLane(withOptions: o)
    }

    /* Beta 배포 (Relase 빌드 -> Testflight 배포) **/
    func betaLane(withOptions options: Options?) {
        desc("codeSigning -> versioning -> build -> upload(StoreConnect) -> testflight -> upload dsyms -> sendToTeams")
        
        var o: Options = options ?? Options()
        o.deploy_mode = .testflight
        
        if o.use_git_push == nil { o.use_git_push = false }
        
        customLane(withOptions: o)
    }
    
    /* Beta 배포 (Relase 빌드 -> AppStore 배포 -> 리뷰) **/
    func releaseLane(withOptions options: Options?) {
        desc("codeSigning -> versioning -> build -> upload(StoreConnect) -> store review -> -> upload dsyms -> sendToTeams")
        
        var o: Options = options ?? Options()
        o.deploy_mode = .appstore
       
        if o.use_git_push == nil { o.use_git_push = false }
        
        customLane(withOptions: o)
    }
    
    
    /* 프로젝트에 설정된 인증서, 프로비저닝으로 빌드 시도, 배포타입은 정해야함.**/
    func simpleLane(withOptions options: Options?) {
        desc("versioning -> build -> upload(StoreConnect) -> testflight")
        
        // step.1 - increment version, build number
        versioningLane(withOptions: options)
        // step.2 - build
        buildLane(withOptions: options)
        // step.3 - upload to appstore
        uploadToAppStoreLane(withOptions: options)
    }
    
    func versioningAndGitPushLane(withOptions options: Options?) {
        let o = options ?? Options()
        readyLane(withOptions: o)
        versioningLane(withOptions: o)
        gitCommitAndPushLane(withOptions: o)
    }
    
    // MARK: - Custom lane
    
    func customLane(withOptions options: Options?) {
        // step.1 - ready
        readyLane(withOptions: options)
        // step.2 - code signing
        syncCodeSigningLane(withOptions: options)
        // step.3 - increment version, build number
        versioningLane(withOptions: options)
        // step.4 - build
        buildLane(withOptions: options)
        // step.5 - upload to appbox
        uploadToAppBoxLane(withOptions: options)
        // step.6 - upload to appstore
        uploadToAppStoreLane(withOptions: options)
        // step.7 - send message
        sendMessageToTeamsLane(withOptions: options)
        // step.8 - git commit & push
        gitCommitAndPushLane(withOptions: options)
        // step.9 - dsym
        uploadDSYMsLane(withOptions: options)

    }
    
    // MARK: - biz Lanes
    
    /**
     Ready
     
     $ fastlane syncCodeSigning
     
    */
    func readyLane(withOptions options: Options?) {
        desc("# 준비 과정")
        if let options = options {
            verbose(message: "options: \(options)")
        }
        ENV.printAll()
        // step.1 - update cocoapods
        if options?.use_update_cocoapod == true {
            verbose(message: "*** -- Clean CocoaPods")
            cleanCocoapodsCache()
            verbose(message: "*** -- START CocoaPods")
            cocoapods()
            verbose(message: "*** -- FINISH CocoaPods")
        }
    }
    
    /**
     Sync code signing
     
     $ fastlane syncCodeSigning
     
    */
    func syncCodeSigningLane(withOptions options: Options?) {
        desc("*** -- Sync Code Signing")
        CodeSigning.sync(withOptions: options)
    }
    
    /**
     Renew code signing
     
     $ fastlane renewCodeSigning
     
    */
    func renewCodeSigningLane(withOptions options: Options?) {
        desc("*** -- Renew Code Signing")
        CodeSigning.renew(withOptions: options)
    }
    
    /**
     Versioning
     
     - Parameters:
        - versioning_mode:
            - major: v1.0.0 → v2.0.0
            - minor: v1.0.0 → v1.1.0
            - patch: v1.0.0 → v1.0.1
            - build_number: v1.0.0(1) → v1.0.0(2)
     
     ** Auto:
     $ fastlane versioning versioning_mode:major
    
     ** Manual:
     $ fastlane versioning version:1.1.0 build_number:1
     
     ** Selection
     $ fastlane versioning versioning_mode:selection
    */
    func versioningLane(withOptions options: Options?) {
        guard let versioning_mode = options?.versioning_mode else {
            verbose(message: "*** -- PASSING Versining")
            return
        }
        
        verbose(message: "*** -- START Versining: \(versioning_mode)")

        var oldVersion: String? = nil
        var newVersion: String? = nil

        Versioning.Fetch.xcodeproj { version, buildNumber in
            oldVersion = "v\(version)(\(buildNumber))"
        }
        
        switch versioning_mode {
        case .manual(let info):
            Versioning.Version.set(info.version ?? "")
            Versioning.BuildNumber.set(info.build_number)
            break
        case .bump(let type):
            if type == .build_number {
                Versioning.BuildNumber.incremnet()
            }
            else {
                Versioning.Version.increment(type)
                Versioning.BuildNumber.initailize()
            }
            break
        case .selection:
            Versioning.SelectionMode.run { selectedItem in
                switch selectedItem {
                case .major, .minor, .patch, .build_number:
                    var newOptions = options
                    newOptions?["versioning_mode"] = selectedItem.rawValue
                    self.versioningLane(withOptions: newOptions)
                    break
                case .manual:
                    verbose(message: "*** -- Not Supported")
                    break
                default:
                    break
                }
            }
        case .none:
            break
        }
        
        Versioning.Fetch.xcodeproj { version, buildNumber in
            newVersion = "v\(version)(\(buildNumber))"
            if oldVersion != newVersion {
                ExtentionTarget.allCases.forEach { extensionTarget in
                    Versioning.Version.set(version, target: extensionTarget.name)
                    Versioning.BuildNumber.set(buildNumber, target: extensionTarget.name)
                }
            }
        }
        
        let old = oldVersion ?? "unknow"
        let new = newVersion ?? "unknow"
        verbose(message: "*** -- FINISH Versioning: \(old) -> \(new)")
    }
    
    /**
     Build
     
     - Parameters:
        - build_configuration: Release, Debug
        - deploy_mode: appstore, testflight, uploadOnly, adhoc, inhouse, development, buildOnly
     
     $ fastlane build build_configuration:Release
     $ fastlane build build_configuration:Release  deploy_mode:testflight
    */

    func buildLane(withOptions options: Options?) {
        verbose(message: "### -- START BUILD")
        buildIosApp(workspace: .userDefined(workspace),
                    scheme: .userDefined(scheme) ,
                    clean: .userDefined(true),
                    configuration: .userDefined(options?.build_configuration.rawValue),
                    exportMethod: .userDefined(options?.deploy_mode.exportMethod.rawValue),
                    exportOptions: .userDefined(options?.deploy_mode.exportOptions),
                    //exportXcargs: .userDefined("-allowProvisioningUpdates"),
                    skipProfileDetection: .userDefined(true))
        verbose(message: "### -- FINISH BUILD")
	}
    
    func uploadToAppBoxLane(withOptions options: Options?) {
        if options?.use_upload_appbox == true {
            verbose(message: "### -- START APPBOX")
            let user = "github@9folders.com" // TODO: env에서 ....
            appbox(emails: user, keepSameLink: .userDefined(true))
            let shareURL = laneContext().APPBOX_SHARE_URL
            verbose(message: "### -- FINISH APPBOX ... Share URL: \(shareURL)")
        }
    }
    
    func uploadToAppStoreLane(withOptions options: Options?) {
        switch options?.deploy_mode {
        case .appstore:
            verbose(message: "*** -- START UPLOAD TO APPSTORE")
            uploadToAppStore(apiKeyPath: .userDefined(ENV.fastlane_itc_apikey_path.value))
            verbose(message: "*** -- FINISH UPLOAD TO APPSTORE")
            break
        case .testflight:
            verbose(message: "*** -- START UPLOAD TO TESTFLIGHT")
            pilot(apiKeyPath: .userDefined(ENV.fastlane_itc_apikey_path.value))
            verbose(message: "*** -- FINISH UPLOAD TO TESTFLIGHT")
            break
        default: break
        }
    }
    
    // MARK: - DSYMs

    /// - Upload latest version:
    ///     * $ fastlane uploadDSYMs
    ///
    /// - Refresh select version:
    ///     * $ fastlane uploadDSYMs dsyms_min_version:1.2.5

    func uploadDSYMsLane(withOptions options: Options?) {
        if let min_version = options?.dsyms_min_version {
            verbose(message: "## uploadDSYMs: \(min_version)")
            DSYMs.upload(min_version)
        }
        else {
            switch options?.dsym_upload_mode {
            case .all:
                verbose(message: "## uploadDSYMs: all")
                DSYMs.refreshAll()
                break
            case .latest:
                verbose(message: "## uploadDSYMs: latest")
                if laneContext().DSYM_OUTPUT_PATH.isEmpty == false {
                    uploadSymbolsToCrashlytics(dsymPath: laneContext().DSYM_OUTPUT_PATH)
                }
                else {
                    Versioning.Fetch.xcodeproj { version, buildNumber in
                        DSYMs.upload(version)
                    }
                }
                break
            default:
                verbose(message: "## uploadDSYMs: nothing")
                break
            }
        }
    }
    
    /// - Refresh all
    ///     * $ fastlane refreshDSYMs
    ///
    /// - Refresh minimum version
    ///     * $ fastlane refreshDSYMs dsyms_min_version:1.2.5
    ///
    func refreshDSYMsLane(withOptions options: Options?) {
        if let dsyms_min_version = options?.dsyms_min_version {
            DSYMs.refreshAll(dsyms_min_version)
        }
        else {
            DSYMs.refreshAll()
        }
    }
    
    
    // MARK: - Send Message
    /// - Test ...
    ///     * $ fastlane sendMessageToTeams deploy_mode:testflight --env rework --verbose
    ///

    func sendMessageToTeamsLane(withOptions options: Options?) {
        guard let options = options else {
            verbose(message: "sendMessageToTeams option is nil")
            return
        }
        
        let title: String = {
            switch options.deploy_mode {
            case .development: return "Deploy development(AppBox)"
            case .testflight: return "Deploy testflight"
            case .appstore: return "Deploy appstore"
            default: return "Deploy"
            }
        }()
        

        let message: String = {
            var m = "v\(laneContext().VERSION_NUMBER)(\(laneContext().BUILD_NUMBER))"
            if options.deploy_mode == .development {
                m.append("\nAppBox URL - \(laneContext().APPBOX_SHARE_URL)")
            }            
            return m
        }()
        
        verbose(message: "sendMessageToTeams title: \(title)")
        verbose(message: "sendMessageToTeams message: \(message)")
        
        Teams(title: title, message: message, facts: options.facts).send()
    }
 
    // MARK: - Send Message
    // test fastlane gitCommitAndPushLane use_git_push:true --env rework --verbose
    func gitCommitAndPushLane(withOptions options: Options?) {
        
        guard options?.use_git_push == true else {
            return
        }

        var o = options ?? Options()
        if options?.gitCommitMessage == nil || options?.gitCommitMessage?.isEmpty == true {
            Versioning.Fetch.xcodeproj { version, buildNumber in
                let defaultMessage = "Re:work v\(version) (\(buildNumber))"
                o.gitCommitMessage = defaultMessage
                verbose(message: "git defaultMessage: \(defaultMessage)")
                self.gitUpdate(withOptions: o)
            }
        }
        else {
            self.gitUpdate(withOptions: o)
        }
    }
    
    func gitUpdate(withOptions options: Options?) {
        if let gitCommitMessage = options?.gitCommitMessage, gitCommitMessage.isEmpty == false {
            verbose(message: "git commit: \(gitCommitMessage)")
            let prefix = "[*] Fastlane -"
            let message = "\(prefix) \(gitCommitMessage)"
            gitCommit(path: ["Okestra.xcodeproj/project.pbxproj"], message: message)
            
            if let gitLocalBranch = options?.gitLocalBranch, let gitRemoteBranch = options?.gitRemoteBranch {
                verbose(message: "git branch local: \(gitLocalBranch), remote: \(gitRemoteBranch)")
                pushToGitRemote(localBranch: .userDefined(gitLocalBranch), remoteBranch: .userDefined(gitRemoteBranch))
            }
            else {
                pushToGitRemote()
            }
        }
        if let gitTagMessage = options?.gitTagMessage, gitTagMessage.isEmpty == false {
            verbose(message: "git tag: \(gitTagMessage)")
            pushGitTags(tag: .userDefined(gitTagMessage))
        }
    }
}



