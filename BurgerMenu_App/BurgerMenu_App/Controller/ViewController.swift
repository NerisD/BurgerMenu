//
//  ViewController.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 21/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var urlBurgerComponent = URLComponents()
    var burger: [Burger] = []
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getApiBugerData()
    }
    
    
    func composeURLForBurgerList () -> URL {
        urlBurgerComponent.scheme = "https"
        urlBurgerComponent.host = "uad.io/"
        urlBurgerComponent.path = "bigburger/"
        
        return URL(string: urlBurgerComponent.url?.absoluteString ?? "https://uad.io/bigburger/")!
    }
    
    func getApiBugerData() {
        let urlBurgerAPI = composeURLForBurgerList()
        var request = URLRequest (url: urlBurgerAPI)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            if let error = error {
                print(error)
            }
            return
        }
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([Burger].self, from: data)
            self.burger = result
            print(self.burger)
        } catch {
            print("error with my API", error.localizedDescription)
            }
        }.resume()
    }


}

