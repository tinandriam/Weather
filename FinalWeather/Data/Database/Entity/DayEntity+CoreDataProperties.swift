import Foundation
import CoreData

extension DayEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<DayEntity> {
        return NSFetchRequest<DayEntity>(entityName: "DayEntity")
    }

    @NSManaged var date: Date
    @NSManaged var mainWeather: String
    @NSManaged var maxTemp: Double
    @NSManaged var minTemp: Double
    @NSManaged var temperature: Double
    @NSManaged var windSpeed: Double
    @NSManaged var location: LocationEntity?

}

extension DayEntity: Identifiable {

}
