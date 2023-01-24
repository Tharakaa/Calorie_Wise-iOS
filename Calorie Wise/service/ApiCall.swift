//
//  ApiCall.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-04.
//

import UIKit

// Class handles all API calls of the appilcation.
class ApiCall: ObservableObject{
    
    // backend URL
    static let baseURL = "https://calorie-wise.onrender.com/api"
    // static object used to hold user data after login in. logged in user is checked using this.
    static var user: UserDTO? = nil
    
    static var delegate:ListItemDelegate!
    
    // check if the user is logged in
    static func isLoggedIn() -> Bool {
        return (user != nil && user?._id != nil && user?._id.trimmingCharacters(in: .whitespacesAndNewlines) != "")
    }
    
    // Clear saved user data on logout.
    static func logout() {
        user = nil
        let userDef:UserDefaults = .standard;
        let dictionary = userDef.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDef.removeObject(forKey: key)
        }
    }
    
    // load data from saved dictionary and login again on app open.
    static func loadData() {
        let userDef:UserDefaults = .standard;
        let _id = userDef.string(forKey: "id")
        if (_id != nil && _id?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            let username = userDef.string(forKey: "username")
            let name = userDef.string(forKey: "name")
            user = UserDTO(_id: _id!, username: username!, name: name!, password: "")
        }
    }
    
    static func fetchCategories(completion:@escaping ([CategoryDTO]?) -> ()) {
        let urlPath = (baseURL + "/getCategories")
        let url = URL(string: urlPath)!
        // URL sessions are used to fetch data async without disturbing the main thread.
        URLSession.shared.dataTask(with: url) { data, response, error in
            let categories:[CategoryDTO]?;
            if (data != nil) {
                // fetched data is parsed using the relevant class.
                categories = try? JSONDecoder().decode([CategoryDTO].self, from: data!)
            } else {
                categories = nil
            }
            // After retriving the response data is sent using the main thread.
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func fetchRecipesForCategory(minCal: Int, maxCal: Int, completion:@escaping ([ItemDTO]?) -> ()) {
        let urlPath = (baseURL + "/getItemsForCategory")
        let url = URL(string: urlPath)!
        
        let parameters: [String: Any?] = ["minCal": minCal, "maxCal": maxCal, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let categories:[ItemDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([ItemDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func searchRecipes(searchTerm: String, completion:@escaping ([ItemDTO]?) -> ()) {
        let urlPath = (baseURL + "/searchItems")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["searchParam": searchTerm, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let categories:[ItemDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([ItemDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func getBookmarkedForUser(completion:@escaping ([ItemDTO]?) -> ()) {
        let urlPath = (baseURL + "/getBookmarksForUser/" + (user?._id ?? ""))
        let url = URL(string: urlPath)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let categories:[ItemDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([ItemDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func register(parameters: [String:String?], completion:@escaping (Int?) -> ()) {
        let urlPath = (baseURL + "/register")
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse?.statusCode == 400) {
                DispatchQueue.main.async {
                    completion(1)
                }
            } else {
                //self.user = try? JSONDecoder().decode(UserDTO.self, from: data!)
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }.resume()
        
    }
    
    static func login(parameters: [String:String?], completion:@escaping (Int?) -> ()) {
        let urlPath = (baseURL + "/login")
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse?.statusCode == 401) {
                DispatchQueue.main.async {
                    completion(1)
                }
            } else {
                // On successful login. Data is saved to a dictionary to persists data even after app close.
                self.user = try? JSONDecoder().decode(UserDTO.self, from: data!)
                let userDef:UserDefaults = .standard;
                userDef.set(self.user?._id, forKey: "id")
                userDef.set(self.user?.username, forKey: "username")
                userDef.set(self.user?.name, forKey: "name")
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }.resume()
        
    }
    
    // Fetch images from backend. After fetching an UIImage is generated and sent.
    static func fetchCategoryImage(path: String, completion:@escaping (UIImage) -> ()) {
        let urlPath = (baseURL + "/public/" + path)
        let url = URL(string: urlPath)!
        // Fetch Image Data
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }).resume()
        
    }
    
    static func fetchProductImage(path: String, completion:@escaping (UIImage) -> ()) {
        let urlPath = (baseURL + "/public/img/" + path)
        let url = URL(string: urlPath)!
        // Fetch Image Data
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }).resume()
        
    }
    
    static func addBookmark(item: String, completion:@escaping () -> ()) {
        let urlPath = (baseURL + "/saveBookmark")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["item": item, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    static func removeBookmark(item: String, completion:@escaping () -> ()) {
        let urlPath = (baseURL + "/removeBookmark")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["item": item, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    
    
}
