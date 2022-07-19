var appIdentifier: String { return ENV.app_identifier.value } // The bundle identifier of your app
var appleID: String { return ENV.apple_id.value } // Your Apple email address

var workspace: String { return ENV.workspace.value }
var project: String { return ENV.project.value }
var scheme: String { return ENV.scheme.value }

enum ExtentionTarget: String, CaseIterable {
    case share
    case notification
    case spotlight
    case upnext = "widget-upnext"
    case intent = "widget-intent"
            
    func appIdentifier(_ parentAppId: String) -> String {
        let prefix: String = "extension"
        return "\(parentAppId).\(prefix)-\(self.rawValue)"
    }
    
    var name: String {
        switch self {
        case .share: return "ShareExtension"
        case .notification: return "NotificationExtension"
        case .spotlight: return "SpotlightExtension"
        case .upnext: return "UpNextWidgetExtension"
        case .intent: return "WidgetIntent"
        }
    }
}

struct ReworkEnterprise {
    
    static var allTarget: [String] {
        let targets = ["ReWork"] + ExtentionTarget.allCases.map({ $0.name })
        let suffix = "Enterprise"
        return targets.map({ "\($0) \(suffix)" })
    }

    static var allIdentifiers: [String] {
        let baseIdentifier = "com.rework.app.enterprise"
        let extensionIdentifiers = ExtentionTarget.allCases.map({ $0.appIdentifier(baseIdentifier) })
        return [baseIdentifier] + extensionIdentifiers
    }
}
