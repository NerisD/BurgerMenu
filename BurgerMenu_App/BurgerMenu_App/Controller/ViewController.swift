//
//  ViewController.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 21/05/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var burgerListTableView: UITableView!
    
    var urlBurgerComponent = URLComponents()
    var burger: [Burger] = []
    
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    var burgerToCoreData : BurgerMenuDB!
    var burgers:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(saveToCoreData))
        burgerListTableView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        burgerListTableView.delegate = self
        burgerListTableView.dataSource = self
        getApiBugerData()
        
        DispatchQueue.main.async {
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            self.context = self.appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "BurgerMenuDB")
            
            do {
                self.burgers = try self.context.fetch(fetchRequest)
                
            } catch {
                print("Error for Entity initialisation \(error)")
            }
            
        }
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
    
    @objc func saveToCoreData(sender: UILongPressGestureRecognizer) {

                if sender.state == UIGestureRecognizer.State.began {
                    let touchPoint = sender.location(in: burgerListTableView)
                    if let indexPath = burgerListTableView.indexPathForRow(at: touchPoint) {
                        print("Long press Pressed:\(indexPath)")
                        
                        let request: NSFetchRequest<BurgerMenuDB> = BurgerMenuDB.fetchRequest()
                        
                        request.predicate = NSPredicate(format: "ref LIKE %@", burger[indexPath.row].ref!)
                        
                        do {
                            let result = try context.fetch(request)
                            if result.count == 0 {
                                burgerToCoreData = BurgerMenuDB(context: context)
                            } else {
                                burgerToCoreData = result.first
                            }
                            
                            context.performAndWait {
                                burgerToCoreData.nombre += 1
                                burgerToCoreData.ref = burger[indexPath.row].ref
                                burgerToCoreData.thumbnail = burger[indexPath.row].thumbnail
                                burgerToCoreData.title = burger[indexPath.row].title
                                burgerToCoreData.price = "\(burger[indexPath.row].price!.formatnumber())"
                                burgerToCoreData.details = burger[indexPath.row].description
                                
                                do {
                                    print("Save to CoreData")
                                    try context.save()
                                }catch {
                                    print("Saving to CoreData Error : \(error)")
                                }
                            }
                            
                        }catch {
                            fatalError("Unresolved error \(error)")
                        }
                    }
                }


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

