import Flutter
import UIKit
import GoogleMaps 

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // GMSServices.provideAPIKey("AIzaSyAi25AX1_xo9G96TcXf5m5J_Iri_S5iSNU") 
    GMSServices.provideAPIKey("AIzaSyAtMW7mnkuwGSt_ayHbz-2FA_glYe8f-Yw") 

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
