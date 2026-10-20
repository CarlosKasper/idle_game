import Flutter
import UIKit
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var nativeAdFactory: MediumNativeAdFactory?
  private var adRegistry: FlutterPluginRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillTerminate(_ application: UIApplication) {
    if let registry = adRegistry, nativeAdFactory != nil {
      FLTGoogleMobileAdsPlugin.unregisterNativeAdFactory(registry, factoryId: "mediumNative")
      nativeAdFactory = nil
    }
    super.applicationWillTerminate(application)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    // Registro único dos plugins (registrar de novo causa "Duplicate plugin key").
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Factory do Native Ad precisa ser registrada no mesmo engine do plugin do AdMob.
    let factory = MediumNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      engineBridge.pluginRegistry,
      factoryId: "mediumNative",
      nativeAdFactory: factory
    )
    nativeAdFactory = factory
    adRegistry = engineBridge.pluginRegistry
  }
}
