//
//  ViewController.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 21/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var burgerListTableView: UITableView!
    
    
    var urlBurgerComponent = URLComponents()
    var burger: [Burger] = []
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        burgerListTableView.delegate = self
        burgerListTableView.dataSource = self
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
            
            DispatchQueue.main.async {
                self.burgerListTableView.reloadData()
            }
            
        } catch {
            print("error with my API", error.localizedDescription)
            }
        }.resume()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return burger.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "burgerCell", for: indexPath) as! BurgerCustomViewCell
        
        cell.burgerImage.loadImageUsingCache(with: burger[indexPath.row].thumbnail!)
        cell.burgerTitle.text = burger[indexPath.row].title
        cell.burgerDescription.text = burger[indexPath.row].description
        cell.burgerPrice.text = "\(burger[indexPath.row].price!.formatnumber())"
        
        return cell
    }
}

