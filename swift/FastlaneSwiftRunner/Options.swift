//
//  Parameters.swift
//  FastlaneRunner
//
//  Created by inchan on 2022/03/03.
//  Copyright © 2022 Joshua Liebowitz. All rights reserved.
//

import Foundation

typealias Options = [String: String]

extension Options {
    
    // 버전관리 모드 (none, patch, minor, major, build_number)
    var versioning_mode: Versioning_Mode {
        return Versioning_Mode(withOptions: self) ?? .bump(.build_number)
    }
    
    // 배포 모드 (appstore, testflight, uploadOnly, adhoc, inhouse, development, buildOnly)
    var deploy_mode: Deploy_Mode {
        get {
            return Deploy_Mode(withOptions: self) ?? .testflight
        }
        set {
            self[Deploy_Mode.key] = newValue.rawValue
        }
    }
    
    // 빌드 구성 (Releaes, Debug)
    var build_configuration: Build_Configuration {
        if let build_config = Build_Configuration(withOptions: self) {
            return build_config
        }
        else {
            switch self.deploy_mode {
            case .development: return .Debug
            default: return .Release
            }
        }
    }
    
    /// 빌드 ExportMethod (appstore, ad-hoc, enterprise, development)
    var build_export_method: Build_Export_Method {
        if let export_method = Build_Export_Method(withOptions: self) {
            return export_method
        }
        else {
            return self.deploy_mode.exportMethod
        }
    }
    
    /// DSYM 업로드 타입
    var dsym_upload_mode: DSYM_Upload_Mode? {
        get {
            return DSYM_Upload_Mode(withOptions: self)
        }
        set {
            if let newValue = newValue {
                self[DSYM_Upload_Mode.key] = newValue.rawValue
            }
            else {
                self[DSYM_Upload_Mode.key] = .none
            }
        }
    }
    
    /// 선택된 버전
    var version: String? {
        return self["version"]
    }
    
    /// 선택된 빌드 넘버
    var build_number: String? {
        return self["build_number"]
    }
    
    // 코코아팟 업데이트 사용여부
    var use_update_cocoapod: Bool? {
        get {
            return self["use_update_cocoapod"] == "true"
        }
        set {
            self["use_update_cocoapod"] = (newValue == true) ? "true" : "false"
        }
    }
    
    /// 앱박스 사용여부
    var use_upload_appbox: Bool? {
        get {
            return self["use_upload_appbox"] == "true"
        }
        set {
            self["use_upload_appbox"] = (newValue == true) ? "true" : "false"
        }
    }
        
    /// 깃 푸시 사용여부
    var use_git_push: Bool? {
        get {
            return self["use_git_push"] == "true"
        }
        set {
            self["use_git_push"] = (newValue == true) ? "true" : "false"
        }
    }
    
    /// 깃 테그 사용여부
    var use_git_tag: Bool? {
        get {
            return self["use_git_tag"] == "true"
        }
        set {
            self["use_git_tag"] = (newValue == true) ? "true" : "false"
        }
    }
    
    /// 깃 커밋 메시지
    var gitCommitMessage: String? {
        get {
            return self["gitCommitMessage"]
        }
        set {
            self["gitCommitMessage"] = newValue
        }
    }
    
    /// 깃 테그 메시지
    var gitTagMessage: String? {
        get {
            return self["gitTagMessage"]
        }
        set {
            self["gitTagMessage"] = newValue
        }
    }

    var gitBranch: String? {
        get {
            return self["gitBranch"]
        }
    }
    
    /// dsyms - 다운받을 최소 버전
    var dsyms_min_version: String? {
        get {
            return self["dsyms_min_version"]
        }
        set {
            self["dsyms_min_version"] = newValue
        }
    }
    
}


extension Options {
    var facts: [[String: String]] {
        var facts: [[String: String]] = []
        facts.append(self.deploy_mode.asFact())
        return facts
    }
}
