import CoreLocation

class SolarTimeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var current: EdoTime?

    private let locationManager: CLLocationManager
    private var currentCoord: CLLocationCoordinate2D?
    var timer: Timer?

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateView()
        })
    }

    deinit {
        timer?.invalidate()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoord = locations.first?.coordinate
        updateView()
    }

    func updateView() {
        let now = Date()
        if let loc = currentCoord {
            current = EdoTime(geoloc: loc, now: now)
        }
    }
}
