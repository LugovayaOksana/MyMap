//
//  ContentView.swift
//  MyMap
//
//  Created by Oksana on 09.04.2022.
//

import SwiftUI
import YandexMapsMobile

struct YMKView: View {
    @EnvironmentObject var model: Model
    @State var show = false
    @State var bottomSheetOpened = false
    @State private var bottomState = CGSize.zero
    @State var viewState = CGSize.zero
    @State var showFull = false
    @State var showFillters = false
    @State var showModal = false
    
    var body: some View {
        ZStack {
            YandexMapsViewContainer()
            mapControllers
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }.edgesIgnoringSafeArea(.all)
    }
    
    var mapControllers: some View {
        VStack(spacing:30) {
            Button(action: {
                onZoomIn()
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .frame(width:40, height:40)
                    .background(Color.white)
                    .clipShape(Circle())
            })
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 1)
            
            Button(action: {
                onZoomOut()
            }, label: {
                Image(systemName: "minus")
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .frame(width:40, height:40)
                    .background(Color.white)
                    .clipShape(Circle())
            })
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 1)
            
            Button(action: {
                onUserLocation()
            }, label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .frame(width:40, height:40)
                    .background(Color.white)
                    .clipShape(Circle())
            })
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 1)
        }
    }
    
    
    private func onZoomIn () {
        model.zoomIn = true
        print("TAP ON_ZOOM_IN")
        model.zoomIn = false
    }
    
    private func onZoomOut () {
        model.zoomOut = true
        print("TAP ON_ZOOM_OUT")
        model.zoomOut = false
    }
    
    private func onUserLocation () {
        model.showUserLocation = true
        print("TAP ON_USER_LOCATION")
        model.showUserLocation = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        YMKView()
    }
}

struct YandexMapsViewContainer: UIViewRepresentable {
    @EnvironmentObject var model: Model
    
    // Listen to changes on the locationManager
    @ObservedObject var locationManager = LocationManager()
    
    
    var initialZoom = 12
    
    let START_LOCATION = YMKPoint(latitude: 55.75370903771494, longitude: 37.61981338262558)
    
    func makeUIView(context: Context) -> YMKMapView {
        let cameraPosition = YMKCameraPosition(
            target: START_LOCATION, zoom: Float(initialZoom), azimuth: 0, tilt: 0)
        
        let mapView = YMKMapView(frame: CGRect.zero)
        mapView.mapWindow.map.move(
            with: cameraPosition,
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil
        )
        //        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(locationManager)
        return mapView
    }
    
    func updateUIView(_ uiView: YMKMapView, context: Context) {
        context.coordinator.addMarkers(mapView: uiView)
        
        if model.zoomIn {
            context.coordinator.zoom(mapView: uiView, zoomStep: 1)
        }
        
        if model.zoomOut {
            context.coordinator.zoom(mapView: uiView, zoomStep: -1)
        }
        
        if model.showUserLocation {
            centerMapLocation(map: uiView )
        }
    }
    
    func makeCoordinator() -> YMKCoordinator {
        let coordinator = YMKCoordinator()
        return coordinator
    }
    
    // custom functions
    func centerMapLocation(map: YMKMapView) {
        guard let myLocation = locationManager.lastKnownLocation else { return }
        
        print("User's location: \(myLocation)")
        //        guard let location = location else { print("Failed to get user location"); return }
        
        let location = YMKPoint(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        
        map.mapWindow.map.move(
            with: YMKCameraPosition(target: location, zoom: 18, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5)
        )
    }
}

class YMKCoordinator: NSObject, YMKClusterListener, YMKClusterTapListener, YMKMapObjectTapListener, YMKMapInputListener {
    
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        //
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        //
    }
    
    var collection: YMKClusterizedPlacemarkCollection?
    
    private let FONT_SIZE: CGFloat = 15
    private let MARGIN_SIZE: CGFloat = 3
    private let STROKE_SIZE: CGFloat = 3
    
    
    // mapView.mapWindow.map.addTapListener(with: self)
    
    func onClusterTap(with cluster: YMKCluster) -> Bool {
        let alert = UIAlertController(
            title: "Tap",
            message: String(format: "Tapped cluster with %u items", cluster.size),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //        present(alert, animated: true, completion: nil)
        
        // We return true to notify map that the tap was handled and shouldn't be
        // propagated further.
        return true
    }
    
    func zoom(mapView: YMKMapView, zoomStep: Int) {
        let cameraPosition = YMKCameraPosition(
            target: mapView.mapWindow.map.cameraPosition.target,
            zoom: mapView.mapWindow.map.cameraPosition.zoom + Float(zoomStep),
            azimuth: 0,
            tilt: 0)
        mapView.mapWindow.map.move(
            with: cameraPosition,
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.3),
            cameraCallback: nil
        )
    }
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func playcemarkImage() -> UIImage {
        let scale = UIScreen.main.scale
        let imageRadius = 20.0
        let internalRadius = imageRadius + 3 * scale
        let externalRadius = internalRadius + 3 * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    
    func onClusterAdded(with cluster: YMKCluster) {
        // We setup cluster appearance and tap handler in this method
        cluster.appearance.setIconWith(clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
    
    var yandexPlacemark: UIImage = {
        let image = UIImage()
        image.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    func addMarkers(mapView: YMKMapView) {
        let circle = UIImage(systemName:"circle.fill")!.withTintColor(UIColor.blue)
        let size = CGSize(width: 25, height: 25)
        
        yandexPlacemark = UIGraphicsImageRenderer(size:size).image {
            
            _ in circle.draw(in:CGRect(origin:.zero, size:size))
        }
        
        
        //если нужно создать кластеры
        /*
         collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
         collection?.addTapListener(with: self)*/
        
        
        
        //        collection?.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        //
        return true
    }
}
