import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private let METHOD_CHANNEL = "com.example.device_info/methods"
    private let EVENT_CHANNEL = "com.example.device_info/events"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Initialize Google Maps
        GMSServices.provideAPIKey("AIzaSyDY470qifXiaxJ2KB4xwXzrsf9Yd74DYEw")
        
        // Register plugins
        GeneratedPluginRegistrant.register(with: self)

        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        // -------------------------------
        // MethodChannel for one-time calls
        // -------------------------------
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }

            switch call.method {
            case "getBatteryLevel":
                let level = self.getBatteryLevel()
                if level == -1 {
                    result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
                } else {
                    result(level)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // -------------------------------
        // EventChannel for battery state updates
        // -------------------------------
        let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(BatteryStateStreamHandler())

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // -------------------------------
    // Helper: Get current battery level
    // -------------------------------
    private func getBatteryLevel() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = Int(UIDevice.current.batteryLevel * 100)
        return level >= 0 ? level : -1
    }
}

// -------------------------------
// StreamHandler for battery state
// -------------------------------
class BatteryStateStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateChanged),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }

    @objc private func batteryStateChanged(notification: Notification) {
        let state: String
        switch UIDevice.current.batteryState {
        case .charging: state = "charging"
        case .full: state = "full"
        case .unplugged: state = "discharging"
        default: state = "unknown"
        }
        eventSink?(state)
    }
}
