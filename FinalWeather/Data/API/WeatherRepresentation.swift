import Foundation

struct WeatherRepresentation: Codable {

// array of "daily forecasts"
    let daily: [DailyRepresentation]
}

struct MainWeatherRepresentation: Codable {

    // Main weather : description of the sky
    let main: String
}

struct DailyRepresentation: Codable {
    // date in Timestamp
    let dt: Date

    // temperatures in the day
    let temp: TemperatureRepresentation

    // windSpeed in m/s
    let windSpeed: Double

    // Main weather : description of the sky
    let weather: [MainWeatherRepresentation]
}

struct TemperatureRepresentation: Codable {
    // minimal temperature in the day, in °C.
    let min: Double

    // maximal temperature in the day, in °C.
    let max: Double

    // average temperature in the day, in °C.
    let day: Double
}
