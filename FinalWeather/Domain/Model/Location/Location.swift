import Foundation
import CoreLocation

struct Location {

    // name of the city chosen
    let cityName: String

    // coordinates of the chosen city
    let coordinates: CLLocationCoordinate2D

    var today: Day?

    // forecast weather at the location
    var forecast: [Day]

    let entity: LocationEntity

    init(locationEntity: LocationEntity) {
        self.entity = locationEntity
        self.cityName = locationEntity.cityName
        self.coordinates = CLLocationCoordinate2D(
            latitude: locationEntity.latitude,
            longitude: locationEntity.longitude
        )
        let today = Calendar.current.startOfDay(for: Date())
        let days: Set<DayEntity> = locationEntity.days ?? []
        self.forecast = days.filter({ (day) -> Bool in
            return Calendar.current.startOfDay(for: day.date) > today
        }).map({ (dayEntity) -> Day in
            return Day(dayEntity: dayEntity)
        }).sorted(by: { (day1, day2) -> Bool in
            day1.date < day2.date
        })

        self.today = days.first(where: { (day) -> Bool in
            return Calendar.current.startOfDay(for: day.date) == today
        }).map({ (dayEntity) -> Day in
            return Day(dayEntity: dayEntity)
        })
    }
}
