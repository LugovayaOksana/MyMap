//
//  LocationManager.swift
//  MyMap
//
//  Created by Oksana on 09.04.2022.
//

import SwiftUI
import CoreLocation
import YandexMapsMobile
import AVFoundation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject, YMKUserLocationObjectListener {
    
    // Publish the user's location so subscribers can react to updates
    @Published var lastKnownLocation: CLLocation? = nil
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Notify listeners that the user has a new location
        self.lastKnownLocation = locations.last
    }
    
    func userImage(_ image: UIImage) -> UIImage {
        let scale = UIScreen.main.scale
        let size = CGSize(width: 70, height: 70)
        let imageRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let externalRadius = imageRadius + 0.2 * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        image.draw(in:CGRect(
            origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
            size:size)
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
                
        return image
    }
    
    var userPlacemark: UIImage = {
        let image = UIImage()
        image.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    //location_icon
    func onObjectAdded(with view: YMKUserLocationView) {
        let avatar = UIImage(named: "user")!.withRoundedCorners(radius: 100)
        
        let userImageView:UIImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.image = avatar
        
        userImageView.layer.cornerRadius = 100
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 5
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view.pin.setIconWith(userImage(userImageView.image!))
        view.arrow.setIconWith(userImage(userImageView.image!))
        view.accuracyCircle.fillColor = UIColor.clear
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
}

extension UIImage {
    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addShadow(blurSize: CGFloat = 6.0) -> UIImage {
        
        let shadowColor = UIColor(white:0.0, alpha:0.8).cgColor
        
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: self.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.setShadow(offset: CGSize(width: blurSize/2,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(self.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: self.size.width, height: self.size.height),
                     byTiling:false)
        
        return UIImage(cgImage: context.makeImage()!)
    }
}
