

import Foundation
struct WeatherData : Codable
{
    let name: String
   // let main: Dictionary <String, Float>
    let main: Main
   // let weather : Array <Weather>
    let weather : [Weather]
}
struct Main: Codable
{
    let temp: Double
    
}
struct Weather: Codable
{
    let id: Int
}



