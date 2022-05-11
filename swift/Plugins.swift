import Foundation
/**
 Deploy Development, Ad-Hoc and In-house (Enterprise) iOS applications directly to the devices from your Dropbox account.

 - parameters:
   - emails: Comma-separated list of email address that should receive application installation link
   - appboxPath: If you've setup AppBox in the different directory then you need to mention that here. Default is '/Applications/AppBox.app'
   - message: Attach personal message in the email. Supported Keywords: The {PROJECT_NAME} - For Project Name, {BUILD_VERSION} - For Build Version, and {BUILD_NUMBER} - For Build Number
   - keepSameLink: This feature will keep same short URL for all future build/IPA uploaded with same bundle identifier. If this option is enabled, you can also download the previous build with the same URL. Read more here - https://docs.getappbox.com/Features/keepsamelink/
   - dropboxFolderName: You can change the link by providing a Custom Dropbox Folder Name. By default folder name will be the application bundle identifier. So, AppBox will keep the same link for the IPA file available in the same folder. Read more here - https://docs.getappbox.com/Features/keepsamelink/

 Deploy Development, Ad-Hoc and In-house (Enterprise) iOS applications directly to the devices from your Dropbox account.
*/
public func appbox(emails: String,
                   appboxPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                   message: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                   keepSameLink: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                   dropboxFolderName: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let emailsArg = RubyCommand.Argument(name: "emails", value: emails, type: nil)
let appboxPathArg = appboxPath.asRubyArgument(name: "appbox_path", type: nil)
let messageArg = message.asRubyArgument(name: "message", type: nil)
let keepSameLinkArg = keepSameLink.asRubyArgument(name: "keep_same_link", type: nil)
let dropboxFolderNameArg = dropboxFolderName.asRubyArgument(name: "dropbox_folder_name", type: nil)
let array: [RubyCommand.Argument?] = [emailsArg,
appboxPathArg,
messageArg,
keepSameLinkArg,
dropboxFolderNameArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "appbox", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Detects current build number defined by CI system
*/
public func ciBuildNumber() {

let args: [RubyCommand.Argument] = []
let command = RubyCommand(commandID: "", methodName: "ci_build_number", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the version number of your app in the App Store

 - parameters:
   - bundleId: Bundle ID of the application
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration
   - country: Pass an optional country code, if your app's availability is limited to specific countries
*/
public func getAppStoreVersionNumber(bundleId: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                     xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                     target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                     scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                     buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                     country: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let bundleIdArg = bundleId.asRubyArgument(name: "bundle_id", type: nil)
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let countryArg = country.asRubyArgument(name: "country", type: nil)
let array: [RubyCommand.Argument?] = [bundleIdArg,
xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
countryArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_app_store_version_number", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the build number of your project

 - parameters:
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration
   - plistBuildSettingSupport: support automatic resolution of build setting from xcodeproj if not a literal value in the plist

 This action will return the current build number set on your project's Info.plist. note that you can pass plist_build_setting_support: true, in which case it will return from your xcodeproj.
*/
public func getBuildNumberFromPlist(xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    plistBuildSettingSupport: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let plistBuildSettingSupportArg = plistBuildSettingSupport.asRubyArgument(name: "plist_build_setting_support", type: nil)
let array: [RubyCommand.Argument?] = [xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
plistBuildSettingSupportArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_build_number_from_plist", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the build number of your project

 - parameters:
   - xcodeproj: Optional, you must specify the path to your main Xcode project if it is not in the project root directory or if you have multiple *.xcodeproj's in the root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different build settings for each configuration

 Gets the $(CURRENT_PROJECT_VERSION) build setting using the specified parameters, or the first if not enough parameters are passed.
*/
public func getBuildNumberFromXcodeproj(xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let array: [RubyCommand.Argument?] = [xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_build_number_from_xcodeproj", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the version number of your project

 - parameters:
   - xcodeproj: Optional, you must specify the path to your main Xcode project if it is not in the project root directory or if you have multiple *.xcodeproj's in the root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration

 This action will return path to Info.plist for specific target in your project.
*/
public func getInfoPlistPath(xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                             target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                             scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                             buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let array: [RubyCommand.Argument?] = [xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_info_plist_path", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Extract version number from git branch name

 - parameter pattern: Pattern for branch name, should contain # character in place of version number
*/
public func getVersionNumberFromGitBranch(pattern: String = "release-#") {
let patternArg = RubyCommand.Argument(name: "pattern", value: pattern, type: nil)
let array: [RubyCommand.Argument?] = [patternArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_version_number_from_git_branch", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the version number of your project

 - parameters:
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration
   - plistBuildSettingSupport: support automatic resolution of build setting from xcodeproj if not a literal value in the plist

 This action will return the current version number set on your project's Info.plist. note that you can pass plist_build_setting_support: true, in which case it will return from your xcodeproj.
*/
public func getVersionNumberFromPlist(xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                      target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                      scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                      buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                      plistBuildSettingSupport: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let plistBuildSettingSupportArg = plistBuildSettingSupport.asRubyArgument(name: "plist_build_setting_support", type: nil)
let array: [RubyCommand.Argument?] = [xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
plistBuildSettingSupportArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_version_number_from_plist", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Get the version number of your project

 - parameters:
   - xcodeproj: Optional, you must specify the path to your main Xcode project if it is not in the project root directory or if you have multiple *.xcodeproj's in the root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different build settings for each configuration

 Gets the $(MARKETING_VERSION) build setting using the specified parameters, or the first if not enough parameters are passed.
*/
public func getVersionNumberFromXcodeproj(xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let array: [RubyCommand.Argument?] = [xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "get_version_number_from_xcodeproj", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Increment the build number of your project

 - parameters:
   - buildNumber: Change to a specific build number
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration
   - plistBuildSettingSupport: support automatic resolution of build setting from xcodeproj if not a literal value in the plist

 This action will increment the build number directly in Info.plist
 unless plist_build_setting_support: true is passed in as parameters
*/
public func incrementBuildNumberInPlist(buildNumber: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                        plistBuildSettingSupport: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let buildNumberArg = buildNumber.asRubyArgument(name: "build_number", type: nil)
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let plistBuildSettingSupportArg = plistBuildSettingSupport.asRubyArgument(name: "plist_build_setting_support", type: nil)
let array: [RubyCommand.Argument?] = [buildNumberArg,
xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
plistBuildSettingSupportArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "increment_build_number_in_plist", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Increment build number in xcodeproj

 - parameters:
   - buildNumber: Change to a specific build number
   - xcodeproj: Optional, you must specify the path to your main Xcode project if it is not in the project root directory or if you have multiple *.xcodeproj's in the root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different build settings for each configuration
*/
public func incrementBuildNumberInXcodeproj(buildNumber: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let buildNumberArg = buildNumber.asRubyArgument(name: "build_number", type: nil)
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let array: [RubyCommand.Argument?] = [buildNumberArg,
xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "increment_build_number_in_xcodeproj", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Increment the version number of your project

 - parameters:
   - bumpType: The type of this version bump. Available: patch, minor, major
   - versionNumber: Change to a specific version. This will replace the bump type value
   - omitZeroPatchVersion: If true omits zero in patch version(so 42.10.0 will become 42.10 and 42.10.1 will remain 42.10.1)
   - bundleId: Bundle ID of the application
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different Info.plist build settings for each configuration
   - versionSource: Source version to increment. Available options: plist, appstore
   - country: Pass an optional country code, if your app's availability is limited to specific countries
   - plistBuildSettingSupport: support automatic resolution of build setting from xcodeproj if not a literal value in the plist

 This action will increment the version number directly in Info.plist. 
 unless plist_build_setting_support: true is passed in as parameters
*/
public func incrementVersionNumberInPlist(bumpType: String = "patch",
                                          versionNumber: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          omitZeroPatchVersion: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          bundleId: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          versionSource: String = "plist",
                                          country: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          plistBuildSettingSupport: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let bumpTypeArg = RubyCommand.Argument(name: "bump_type", value: bumpType, type: nil)
let versionNumberArg = versionNumber.asRubyArgument(name: "version_number", type: nil)
let omitZeroPatchVersionArg = omitZeroPatchVersion.asRubyArgument(name: "omit_zero_patch_version", type: nil)
let bundleIdArg = bundleId.asRubyArgument(name: "bundle_id", type: nil)
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let versionSourceArg = RubyCommand.Argument(name: "version_source", value: versionSource, type: nil)
let countryArg = country.asRubyArgument(name: "country", type: nil)
let plistBuildSettingSupportArg = plistBuildSettingSupport.asRubyArgument(name: "plist_build_setting_support", type: nil)
let array: [RubyCommand.Argument?] = [bumpTypeArg,
versionNumberArg,
omitZeroPatchVersionArg,
bundleIdArg,
xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
versionSourceArg,
countryArg,
plistBuildSettingSupportArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "increment_version_number_in_plist", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Increment build number in xcodeproj

 - parameters:
   - bumpType: The type of this version bump. Available: patch, minor, major
   - versionNumber: Change to a specific version. This will replace the bump type value
   - omitZeroPatchVersion: If true omits zero in patch version(so 42.10.0 will become 42.10 and 42.10.1 will remain 42.10.1)
   - bundleId: Bundle ID of the application
   - xcodeproj: optional, you must specify the path to your main Xcode project if it is not in the project root directory
   - target: Specify a specific target if you have multiple per project, optional
   - scheme: Specify a specific scheme if you have multiple per project, optional
   - buildConfigurationName: Specify a specific build configuration if you have different build settings for each configuration
   - versionSource: Source version to increment. Available options: xcodeproj, appstore
   - country: Pass an optional country code, if your app's availability is limited to specific countries
   - plistBuildSettingSupport: support automatic resolution of build setting from xcodeproj if not a literal value in the plist
*/
public func incrementVersionNumberInXcodeproj(bumpType: String = "patch",
                                              versionNumber: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              omitZeroPatchVersion: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                              bundleId: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              xcodeproj: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              target: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              scheme: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              buildConfigurationName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              versionSource: String = "xcodeproj",
                                              country: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              plistBuildSettingSupport: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let bumpTypeArg = RubyCommand.Argument(name: "bump_type", value: bumpType, type: nil)
let versionNumberArg = versionNumber.asRubyArgument(name: "version_number", type: nil)
let omitZeroPatchVersionArg = omitZeroPatchVersion.asRubyArgument(name: "omit_zero_patch_version", type: nil)
let bundleIdArg = bundleId.asRubyArgument(name: "bundle_id", type: nil)
let xcodeprojArg = xcodeproj.asRubyArgument(name: "xcodeproj", type: nil)
let targetArg = target.asRubyArgument(name: "target", type: nil)
let schemeArg = scheme.asRubyArgument(name: "scheme", type: nil)
let buildConfigurationNameArg = buildConfigurationName.asRubyArgument(name: "build_configuration_name", type: nil)
let versionSourceArg = RubyCommand.Argument(name: "version_source", value: versionSource, type: nil)
let countryArg = country.asRubyArgument(name: "country", type: nil)
let plistBuildSettingSupportArg = plistBuildSettingSupport.asRubyArgument(name: "plist_build_setting_support", type: nil)
let array: [RubyCommand.Argument?] = [bumpTypeArg,
versionNumberArg,
omitZeroPatchVersionArg,
bundleIdArg,
xcodeprojArg,
targetArg,
schemeArg,
buildConfigurationNameArg,
versionSourceArg,
countryArg,
plistBuildSettingSupportArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "increment_version_number_in_xcodeproj", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Send a message to your Microsoft Teams channel via the webhook connector

 - parameters:
   - title: The title that should be displayed on Teams
   - message: The message that should be displayed on Teams. This supports the standard Teams markup language
   - facts: Optional facts
   - teamsUrl: Create an Incoming WebHook for your Teams channel
   - themeColor: Theme color of the message card

 Send a message to your Microsoft Teams channel
*/
public func teams(title: String,
                  message: String,
                  facts: [String],
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
