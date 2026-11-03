import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // "Play in background" (YouTube, server switch): the browser asks for the
    // playback audio session only while that switch is on.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ReelwayAudioSession") {
      let channel = FlutterMethodChannel(name: "reelway/audio_session", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { call, result in
        guard call.method == "setPlayback" else { return result(FlutterMethodNotImplemented) }
        let on = (call.arguments as? Bool) ?? false
        do {
          let session = AVAudioSession.sharedInstance()
          if on {
            try session.setCategory(.playback, mode: .moviePlayback)
            try session.setActive(true)
          } else {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            try session.setCategory(.ambient)
          }
          result(nil)
        } catch {
          result(FlutterError(code: "audio_session", message: error.localizedDescription, details: nil))
        }
      }
    }
  }
}
