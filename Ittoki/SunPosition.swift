import Foundation
import CoreLocation

struct Julian {
    /** this implementation cheats and only works for date after Jan. 1, 1970 **/
    let day: Double
    let century: Double

    init(date: Date) {
        let epoch = Double(date.timeIntervalSince1970)
        day = (epoch / 86400) + 2440587.5
        century = (day - 2451545) / 36525
    }
}

struct SunPosition {
    /** Midnight (LST) - reference for finding Dates for Sunrise/Sunset and Solar noon */
    let midnight: Date
    /** Julian calendar information for noon (LST) of the day of calculations */
    let julian: Julian

    let gmLong: Double
    let gmAnom: Double
    let eccentEarthOrbit: Double
    let eqOfCtr: Double
    let trueLong: Double
    let trueAnom: Double
    let radVector: Double
    let appLong: Double
    let meanObliqEcliptic: Double
    let obliqCorr: Double
    let rtAccen: Double
    let declination: Double
    let gamma: Double
    let eqOfTime: Double
    let haSunrise: Double

    /** Solar Noon - seconds after midnight (LST) */
    let solarNoon: Double
    /** Sunrise - seconds after midnight (LST) */
    let sunrise: Double
    /** Sunset - seconds after midnight (LST) */
    let sunset: Double
    /** Sunlight Duration - seconds */
    let sunlightDuration: Double

    init(geoloc: CLLocationCoordinate2D, tzoffset: Int, now: Date) {
        midnight = now.midnight
        let noon = midnight.addingTimeInterval(43200)
        julian = Julian(date: noon)

        let century = julian.century
        gmLong = dblMOD(number: 280.46646 + century * (36000.76983 + century * 0.0003032), modulo: 360) // I
        gmAnom = 357.52911 + century * (35999.05029 - 0.0001537 * century) // J
        eccentEarthOrbit = 0.016708634 - century * (0.000042037 + 0.0000001267 * century) // K
        eqOfCtr = sin(radians(gmAnom)) * (1.914602 - century * (0.004817 + 0.000014 * century)) + sin(radians(2 * gmAnom)) * (0.019993 - 0.000101 * century) + sin(radians(3 * gmAnom)) * 0.000289 // L
        trueLong = gmLong + eqOfCtr // M
        trueAnom = gmAnom + eqOfCtr // N
        radVector = (1.000001018 * (1 - eccentEarthOrbit * eccentEarthOrbit)) / (1 + eccentEarthOrbit * cos(radians(trueAnom)))  // O
        appLong = trueLong - 0.00569 - 0.00478 * sin(radians(125.04 - 1934.136 * century))    // P
        meanObliqEcliptic = 23 + (26 + ((21.448 - century * (46.815 + century * (0.00059 - century * 0.001813)))) / 60) / 60  // Q
        obliqCorr = meanObliqEcliptic + 0.00256 * cos(radians(125.04 - 1934.136 * century))  // R
        rtAccen = degrees(atan2(cos(radians(appLong)), cos(radians(obliqCorr)) * sin(radians(appLong))))  // S
        declination = degrees(asin(sin(radians(obliqCorr)) * sin(radians(appLong))))  // T
        let varGamma = tan(radians(obliqCorr / 2))  // U
        gamma = varGamma * varGamma
        eqOfTime = 4 * degrees(gamma * sin(2 * radians(gmLong)) - 2 * eccentEarthOrbit * sin(radians(gmAnom)) + 4 * eccentEarthOrbit * gamma * sin(radians(gmAnom)) * cos(2 * radians(gmLong)) - 0.5 * gamma * gamma * sin(4 * radians(gmLong)) - 1.25 * eccentEarthOrbit * eccentEarthOrbit * sin(2 * radians(gmAnom))) // V

        haSunrise = degrees(acos(cos(radians(90.833)) / (cos(radians(geoloc.latitude)) * cos(radians(declination))) - tan(radians(geoloc.latitude)) * tan(radians(declination))))  // W
        solarNoon = (720 - 4 * geoloc.longitude - eqOfTime) * 60 + Double(tzoffset) // X (seconds after midnight LST)
        sunrise = solarNoon - haSunrise * 240  // Y (seconds after midnight LST)
        sunset = solarNoon + haSunrise * 240  // Z (seconds after midnight LST)
        sunlightDuration = 480 * haSunrise  // AA (seconds)
    }
}

func dblMOD(number: Double, modulo: Int) -> Double {
    let intpart = floor(number)
    return number - intpart + Double(Int(intpart) % modulo)
}

func radians(_ number: Double) -> Double {
    return number * .pi / 180
}

func degrees(_ number: Double) -> Double {
    return number * 180 / .pi
}
