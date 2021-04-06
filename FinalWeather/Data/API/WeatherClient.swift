import Foundation

class WeatherClient {

    func setError(error: WeatherClientErrorRepresentation) -> WeatherClientError {
        if error.cod == "429" {
            return .tooManyRequests
        } else {
            return .apiError
        }
    }

    func getWeatherData(location: Location, weatherCompletionHandler: @escaping (
                            Result<WeatherRepresentation,
                                   WeatherClientError>
    ) -> Void) {
        let url = URL(string: """
                https://api.openweathermap.org/data/2.5/onecall?\
                lat=\(location.coordinates.latitude)\
                &lon=\(location.coordinates.longitude)\
                &units=metric&exclude=current,minutely,hourly\
                &appid=\(openWeatherApiKey)
                """
        )

        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] data, _, error in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let data = data else { return }
            do {
                let day = try decoder.decode(WeatherRepresentation.self, from: data)
                weatherCompletionHandler(.success(day))
            } catch DecodingError.keyNotFound {
                do {
                    let weatherError = try decoder.decode(WeatherClientErrorRepresentation.self, from: data)
                    print("weatherError: ", weatherError)
                    weatherCompletionHandler(
                        .failure(((self?.setError(error: weatherError) ?? error as? WeatherClientError)! )))
                } catch {
                    print("error: ", error)
                }
            } catch {
                print("error: ", error)
            }
        })
        dataTask.resume()
    }
}
