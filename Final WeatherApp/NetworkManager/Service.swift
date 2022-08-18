//
//  Service.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-14.
//

import Foundation

let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
let geobytesURL = "http://gd.geobytes.com/AutoCompleteCity"

struct Service{
    static let shared = Service()
    
    //MARK: OPENWEATHERAPI
    func performFetchWeather(with urlString: String, complition : @escaping (WeatherModel)->()){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
             session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                if let data = data {
                    do{
                        let decodedData = try JSONDecoder().decode(WeatherMap.self, from: data)
                        let name = decodedData.name , temp = decodedData.main.temp, icon = decodedData.weather[0].icon
                        let weather = WeatherModel(cityName: name, icon: icon, temperature: temp)
                        complition(weather)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }

    // MARK: GEOBYTESAPI - Autocomplete
    func searchForCity(url: URL, completion: @escaping ([String]?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let safeData = String(data: data, encoding: .utf8)
            if let convertedData = safeData?.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode([String].self, from: convertedData)
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}

enum APICall{
    static let APIParam = "&appid=164658d25e900d112bb7215b2abb66b3"
    case geobytes(String)
    case openweather(String)
    var stringURL: String{
        switch self {
        case .openweather(let weather):
            return weatherURL + "?q=\(weather)"
            + "&units=metric" + APICall.APIParam
        case .geobytes(let city):
            return geobytesURL + "?q=\(city)"
        }
    }
}




import Foundation
