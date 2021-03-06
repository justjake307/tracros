//
//  MealPlanningViewController.swift
//  Tracros
//
//  Created by Jake Gray on 7/11/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class MealPlanningViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mealTableView: UITableView!
    
    //MARK: Properties
    var plan: Plan?
    var currentPlannedDay: PlannedDay?
    
    var breakfast: [String]?
    var lunchItems: [String]?
    var dinnerItems: [String]?
    var snackItems: [String]?
    
    //MARK: Objects
    lazy var addBreakfastButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addBreakfastPresed), for: .touchUpInside)
//        button.setTitle("+", for: .normal)
        return button
    }()
    
    lazy var addLunchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addLunchPresed), for: .touchUpInside)
//        button.setTitle("+", for: .normal)
        return button
    }()
    
    lazy var addDinnerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addDinnerPresed), for: .touchUpInside)
//        button.setTitle("+", for: .normal)
        return button
    }()
    
    lazy var addSnackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addSnackPresed), for: .touchUpInside)
//        button.setTitle("+", for: .normal)
        return button
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.layer.cornerRadius = 5
        mealTableView.dataSource = self
        mealTableView.delegate = self
        
        performSegue(withIdentifier: "toCreatePlan", sender: nil)
        
//        let nib = UINib.init(nibName: "AddFoodItemTableViewCell", bundle: nil)
//        mealTableView.register(nib, forCellReuseIdentifier: "addCell")
    }
    
    //MARK: Button Actions
    @objc private func addBreakfastPresed() {
        print("breakfast pressed")
        performSegue(withIdentifier: "toBreakfastSearchVC", sender: self)
    }
    
    @objc private func addLunchPresed() {
        print("Lunch pressed")
        performSegue(withIdentifier: "toLunchSearchVC", sender: self)
    }
    
    @objc private func addDinnerPresed() {
        print("dinner PRessed")
        performSegue(withIdentifier: "toDinnerSearchVC", sender: self)
    }
    
    @objc private func addSnackPresed() {
        print("snack pressed")
        performSegue(withIdentifier: "toSnackSearchVC", sender: self)
    }

    //MARK: Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var mealToPass: Meal?
        guard let meals = currentPlannedDay?.meals?.allObjects as? [Meal] else {return}
        
        switch segue.identifier {
        case "toBreakfastSearchVC":
            mealToPass = meals[0]
        case "toLunchSearchVC":
            mealToPass = meals[1]
        case "toDinnerSearchVC":
            mealToPass = meals[2]
        case "toSnackSearchVC":
            mealToPass = meals[3]
        default:
            print("meal not found")
        }
        guard let destinationVC = segue.destination as? SearchViewController else {return}
    }
}

//MARK: TableViewDelegate
extension MealPlanningViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Breakfast"
        case 1:
            return "Lunch"
        case 2:
            return "Dinner"
        case 3:
            return "Snacks"
        default:
            return "error"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            if breakfast == nil || breakfast?.count == 0 {
                return 1
            } else {
                return (breakfast?.count)!
            }
        case 1:
            guard let items = lunchItems?.count else {return 1}
            return items + 1
        case 2:
            guard let items = dinnerItems?.count else {return 1}
            return items + 1
        case 3:
            guard let items = snackItems?.count else {return 1}
            return items + 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
        if breakfast == nil || breakfast?.count == 0 {
            cell.textLabel?.text = "No Items"
        } else {
            cell.textLabel?.text = "Some tems"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        print("Header view")
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var button = UIButton()
        
        switch section {
        case 0:
            button = addBreakfastButton
            titleLabel.text = "Breakfast"
        case 1:
            button = addLunchButton
            titleLabel.text = "Lunch"
        case 2:
            button = addDinnerButton
            titleLabel.text = "Dinner"
        case 3:
            button = addSnackButton
            titleLabel.text = "Snacks"
        default:
            titleLabel.text = "Error"
        }
        
        button.setImage(#imageLiteral(resourceName: "addNew"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        view.addSubview(titleLabel)
        view.addSubview(button)

        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8).isActive = true

        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true

        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

