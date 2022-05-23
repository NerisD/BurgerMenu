//
//  WishListViewController.swift
//  BurgerMenu_App
//
//  Created by Dimitri SMITH on 23/05/2022.
//

import Foundation
import UIKit
import CoreData


class WishListViewController: UIViewController {
    
    
    @IBOutlet weak var wlBurgerListTableView: UITableView!
    @IBOutlet weak var applePayLogo: UIImageView!
    @IBOutlet weak var wlTotalToPay: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var priceToPayForOneBurger = 0.0
    var totalPriceToPay = 0.0
    
    
    
    
    
    private let persistentContainer = NSPersistentContainer(name: "BurgerMenu_App")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<BurgerMenuDB> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<BurgerMenuDB> = BurgerMenuDB.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        wlBurgerListTableView.delegate = self
        wlBurgerListTableView.dataSource = self
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")

            } else {
                self.setupView()

                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }

                self.updateView()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    private func setupView() {
        setupMessageLabel()

        updateView()
    }

    private func updateView() {
        var hasBurgers = false

        if let burgers = fetchedResultsController.fetchedObjects {
            hasBurgers = burgers.count > 0
        }

        wlBurgerListTableView.isHidden = !hasBurgers
        messageLabel.isHidden = hasBurgers

        activityIndicatorView.stopAnimating()
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any burger yet."
    }
    
    private func updateTotalPrice() {
        totalPriceToPay = totalPriceToPay + priceToPayForOneBurger
        wlTotalToPay.text = Int(totalPriceToPay).formatnumber()
    }
    
}
extension WishListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        wlBurgerListTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        wlBurgerListTableView.endUpdates()

        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                wlBurgerListTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                wlBurgerListTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = wlBurgerListTableView.cellForRow(at: indexPath) as? WishListCustomViewCell {
                // *TODO Update Cell
            }
            break;
        case .move:
            if let indexPath = indexPath {
                wlBurgerListTableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                wlBurgerListTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        @unknown default:
            print(Error.self)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }

}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let burgers = fetchedResultsController.fetchedObjects else { return 0 }
        return burgers.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as? WishListCustomViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let burgerMenuDB = fetchedResultsController.object(at: indexPath)
        
        cell.wlBurgerImage.loadImageUsingCache(with: burgerMenuDB.thumbnail!)
        cell.wlBurgerTitleLabel.text = burgerMenuDB.title
        cell.wlBurgerDescriptionLabel.text = burgerMenuDB.details
        cell.wlUnitPriceLabel.text = "\((Int(burgerMenuDB.price)).formatnumber())"
        cell.wlTotalUnitLabel.text = String(burgerMenuDB.nombre)
        
        priceToPayForOneBurger = Double(burgerMenuDB.nombre * burgerMenuDB.price)
        
        updateTotalPrice()
        
        
        return cell
    }
}
