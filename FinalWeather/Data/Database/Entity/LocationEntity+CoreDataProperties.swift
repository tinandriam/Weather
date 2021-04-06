import Foundation
import CoreData

extension LocationEntity {

    @nonobjc class func request() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged var cityName: String
    @NSManaged var createdAt: Date
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var days: Set<DayEntity>?

}

// MARK: Generated accessors for weather
extension LocationEntity {

    @objc(addWeatherObject:)
    @NSManaged func addToWeather(_ value: DayEntity)

    @objc(removeWeatherObject:)
    @NSManaged func removeFromWeather(_ value: DayEntity)

    @objc(addWeather:)
    @NSManaged func addToWeather(_ values: NSSet)

    @objc(removeWeather:)
    @NSManaged func removeFromWeather(_ values: NSSet)

}

extension LocationEntity: Identifiable {

}
