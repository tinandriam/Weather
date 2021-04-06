import Foundation

struct Day: Equatable {

    // Date in Unix timestamp
    let date: Date

    // Description of the sky
    let mainWeather: String

    // Average temperature in the day, in °C.
    let temperature: Double

    // Minimal temperature in the day, in °C, only for forecasted days
    let minTemp: Double

    // Maximal temperature in the day, in °C, only for forecasted days
    let maxTemp: Double

    // Windspeed in m/s
    let windSpeed: Double

    init(dayEntity: DayEntity) {
        self.date = dayEntity.date
        self.mainWeather = dayEntity.mainWeather
        self.temperature = dayEntity.temperature
        self.minTemp = dayEntity.minTemp
        self.maxTemp = dayEntity.maxTemp
        self.windSpeed = dayEntity.windSpeed

    }

    init(
        date: Date,
        mainWeather: String,
        temperature: Double,
        minTemp: Double,
        maxTemp: Double,
        windSpeed: Double
    ) {
        self.date = date
        self.mainWeather = mainWeather
        self.temperature = temperature
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.windSpeed = windSpeed
    }

}
