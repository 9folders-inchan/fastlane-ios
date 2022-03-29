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
