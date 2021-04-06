import Foundation
import CoreData

protocol DayDataStoreProtocol {
    func createDay(
        date: Date,
        mainWeather: String,
        maxTemp: Double,
        minTemp: Double,
        temperature: Double,
        windSpeed: Double,
        location: LocationEntity
    ) throws -> DayEntity
}

class DayDataStore: DayDataStoreProtocol {

    // MARK: - Parameters

    let context: NSManagedObjectContext

    // MARK: - Initializer

    init(context: NSManagedObjectContext = DatabaseManager.shared.viewContext) {
        self.context = context
    }

    // MARK: - Functions

    func createDay(
        date: Date,
        mainWeather: String,
        maxTemp: Double,
        minTemp: Double,
        temperature: Double,
        windSpeed: Double,
        location: LocationEntity
    ) throws -> DayEntity {
        let dayEntity = DayEntity(context: context)

        dayEntity.date = date
        dayEntity.mainWeather = mainWeather
        dayEntity.maxTemp = maxTemp
        dayEntity.minTemp = minTemp
        dayEntity.temperature = temperature
        dayEntity.windSpeed = windSpeed
        dayEntity.location = location

        do {
            // save
            try context.save()
            return dayEntity
        } catch {
            context.rollback()
            throw DataStoreError.saveFailed(error)
        }
    }
}
