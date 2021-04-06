import Foundation

protocol DayRepositoryProtocol {
    func createDay(forecast: DailyRepresentation, location: Location) throws -> Day
}

class DayRepository: DayRepositoryProtocol {
    func createDay(forecast: DailyRepresentation, location: Location) throws -> Day {
        let dayDataStore = DayDataStore()
        let dayEntity = try dayDataStore.createDay(
            date: forecast.dt,
            mainWeather: forecast.weather[0].main,
            maxTemp: forecast.temp.max,
            minTemp: forecast.temp.min,
            temperature: forecast.temp.day,
            windSpeed: forecast.windSpeed,
            location: location.entity
        )
        return Day(dayEntity: dayEntity)
    }
}
