import Foundation
import CoreLocation

let tokiDigits = ["七", "八", "九", "四", "五", "六", "七", "八", "九", "四", "五", "六"]
let signsEnglish = ["Monkey", "Goat", "Horse", "Snake", "Dragon", "Rabbit", "Tiger", "Ox", "Rat", "Pig", "Dog", "Rooster"]
let signsChar = ["申", "未", "午", "巳", "辰", "卯", "寅", "丑", "子", "亥", "戌", "酉"]

struct EdoTime {
    let toki: String
    let partial: Int
    let zodiacEnglish: String
    let zodiacChar: String

    init(geoloc: CLLocationCoordinate2D, now: Date) {
        var secondsFromGMT: Int {
            TimeZone.current.secondsFromGMT()
        }
        let sun = SunPosition(geoloc: geoloc, tzoffset: secondsFromGMT, now: now)

        let nowSeconds = Int(floor(now.timeIntervalSince(sun.midnight)))
        let sunrise = Int(floor(sun.sunrise))
        let sunset = Int(floor(sun.sunset))

        let dayTokiLength = Double(sunset - sunrise) / 6.0
        let nightTokiLength = (86400.0 - Double(sunset - sunrise)) / 6.0

        var tmpToki: Int
        var tmpPartial = 1000
        if sunrise <= nowSeconds && nowSeconds <= sunset {
            tmpToki = 5
            let tmp = Double(nowSeconds - sunrise)
            let split = modf(tmp / dayTokiLength)
            tmpToki = tmpToki - Int(split.0)
            tmpPartial = tmpPartial - Int(round(1000.0 * split.1))
        } else {
            tmpToki = 11
            var tmp = Double(nowSeconds + (86480 - sunset))
            if sunset < nowSeconds {
                tmp = Double(nowSeconds - sunset)
            }

            let split = modf(tmp / nightTokiLength)
            tmpToki = tmpToki - Int(split.0)
            tmpPartial = tmpPartial - Int(round(1000.0 * split.1))
        }

        toki = tokiDigits[tmpToki]
        partial = tmpPartial
        zodiacEnglish = signsEnglish[tmpToki]
        zodiacChar = signsChar[tmpToki]
    }
}
