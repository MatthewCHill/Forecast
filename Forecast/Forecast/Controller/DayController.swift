//
//  DayController.swift
//  Forecast
//
//  Created by Matthew Hill on 2/21/23.
//

import Foundation

class DayController {
    
    static func fetchDays(completion: @escaping ([Day]?) -> Void) {
        
        // MARK: - Consturct URL
        guard let baseURL = URL(string: Constants.WeatherURL.baseURL) else { completion(nil); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(Constants.WeatherURL.dailyPath)
        
        let apiQuery = URLQueryItem(name: Constants.APIQueryKey.apiKey, value: Constants.APIQueryKey.apiKeyValue)
        let cityQuery = URLQueryItem(name: Constants.APIQueryKey.cityQueryKey, value: Constants.APIQueryKey.cityQueryValue)
        let unitQuery = URLQueryItem(name: Constants.APIQueryKey.mericaQueryKey, value: Constants.APIQueryKey.mericaQueryValue)
        
        urlComponents?.queryItems = [cityQuery,unitQuery,apiQuery]
        guard let finalURL = urlComponents?.url else {completion(nil); return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard let data = data else { completion(nil); return}
            
            do {
                if let topLevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any], let dataArray = topLevel["data"] as? [[String: Any]] {
                
                    let cityWeather = dataArray.compactMap { Day(dictionary: $0, cityName: "city_name") }
                }
            } catch {
                print("Error in Do/Try/Catch: \(error.localizedDescription)")
                completion(nil)
                return
            }
        } .resume()
    }
}
