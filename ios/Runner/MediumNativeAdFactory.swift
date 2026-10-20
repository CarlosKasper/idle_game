import Flutter
import Foundation
import google_mobile_ads
import UIKit

/// Native Ad factory para `factoryId = mediumNative`.
///
/// Renderiza um layout simples com:
/// - ícone
/// - headline
/// - body
/// - call-to-action
/// - AdChoices
///
/// Observação: esse layout é só uma base. Você pode estilizar depois.
final class MediumNativeAdFactory: NSObject, FLTNativeAdFactory {
  func createNativeAd(
    _ nativeAd: GADNativeAd,
    customOptions: [AnyHashable: Any]?
  ) -> GADNativeAdView {
    let adView = GADNativeAdView()

    adView.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1)
    adView.layer.borderColor = UIColor(red: 0.16, green: 0.16, blue: 0.19, alpha: 1).cgColor
    adView.layer.borderWidth = 2
    adView.layer.cornerRadius = 8
    adView.clipsToBounds = true

    let root = UIStackView()
    root.axis = .vertical
    root.spacing = 8
    root.translatesAutoresizingMaskIntoConstraints = false
    adView.addSubview(root)

    NSLayoutConstraint.activate([
      root.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 12),
      root.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -12),
      root.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
      root.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),
    ])

    // Top row (icon + headline)
    let topRow = UIStackView()
    topRow.axis = .horizontal
    topRow.spacing = 10
    topRow.alignment = .center

    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    iconView.contentMode = .scaleAspectFit
    iconView.layer.cornerRadius = 8
    iconView.clipsToBounds = true

    let headlineLabel = UILabel()
    headlineLabel.numberOfLines = 2
    headlineLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
    headlineLabel.textColor = UIColor.white

    topRow.addArrangedSubview(iconView)
    topRow.addArrangedSubview(headlineLabel)

    // Body
    let bodyLabel = UILabel()
    bodyLabel.numberOfLines = 2
    bodyLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    bodyLabel.textColor = UIColor(white: 0.7, alpha: 1)

    // CTA
    let ctaButton = UIButton(type: .system)
    ctaButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .bold)
    ctaButton.setTitleColor(UIColor(red: 0.04, green: 0.04, blue: 0.06, alpha: 1), for: .normal)
    ctaButton.backgroundColor = UIColor(red: 0.29, green: 0.87, blue: 0.50, alpha: 1)
    ctaButton.layer.cornerRadius = 6
    ctaButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

    root.addArrangedSubview(topRow)
    root.addArrangedSubview(bodyLabel)
    root.addArrangedSubview(ctaButton)

    // AdChoices
    let adChoicesView = GADAdChoicesView()
    adChoicesView.translatesAutoresizingMaskIntoConstraints = false
    adView.addSubview(adChoicesView)

    NSLayoutConstraint.activate([
      adChoicesView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 0),
      adChoicesView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: 0),
    ])

    // Bind assets
    adView.nativeAd = nativeAd

    adView.iconView = iconView
    if let icon = nativeAd.icon?.image {
      iconView.image = icon
      iconView.isHidden = false
    } else {
      iconView.isHidden = true
    }

    adView.headlineView = headlineLabel
    headlineLabel.text = nativeAd.headline

    adView.bodyView = bodyLabel
    bodyLabel.text = nativeAd.body
    bodyLabel.isHidden = nativeAd.body == nil

    adView.callToActionView = ctaButton
    ctaButton.setTitle(nativeAd.callToAction, for: .normal)
    ctaButton.isHidden = nativeAd.callToAction == nil

    adView.adChoicesView = adChoicesView

    // Regras do SDK: deixar views clicáveis controladas pelo SDK
    ctaButton.isUserInteractionEnabled = false

    return adView
  }
}
