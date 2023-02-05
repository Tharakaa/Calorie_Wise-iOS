//
//  SearchListView.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit
import Lottie

class SearchListView: UITableViewController, ListItemDelegate, UISearchBarDelegate {
    
    let cellId = "CellId"
    var catId = ""
    var recipes: [ItemDTO] = []
    static var needToRefresh = false;
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        title = "Search"
        
        SearchListView.needToRefresh = false
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        tableView.register(ListItemCell.self, forCellReuseIdentifier: cellId)
        tableView.delaysContentTouches = true
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView.dataSource = self
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        setEmptyMessage("Search Items to Show")
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.setEmptyMessage("Searching")
        ApiCall.searchRecipes(searchTerm: searchBar.text ?? ""){ (recipes) in
            if (recipes == nil) {
                let errorAlert = UIAlertController(title: "Alert", message: "Error occurred when retrieving data", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            if (recipes != nil && recipes!.isEmpty) {
                self.setEmptyMessage("No Items Found")
            } else {
                self.restore()
            }
            self.recipes = recipes ?? []
            self.tableView.reloadData()
            SearchListView.needToRefresh = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (SearchListView.needToRefresh) {
            self.setEmptyMessage("Searching")
            ApiCall.searchRecipes(searchTerm: searchBar.text ?? ""){ (recipes) in
                if (recipes == nil) {
                    let errorAlert = UIAlertController(title: "Alert", message: "Error occurred when retrieving data", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                if (recipes != nil && recipes!.isEmpty) {
                    self.setEmptyMessage("No Items Found")
                } else {
                    self.restore()
                }
                self.recipes = recipes ?? []
                self.tableView.reloadData()
                SearchListView.needToRefresh = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListItemCell
        let dto = self.recipes[indexPath.row]
        let image = (UIImage(systemName: "leaf")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))!
        ApiCall.fetchProductImage(path: dto.imagePath){ (newImage) in
            cell.item = Item(_id: dto._id, name: dto.name, description: dto.description, image: newImage, isBookMarked: dto.isBookMarked, score: dto.score, calorie: dto.calorie, protein: dto.protein, fat: dto.fat, carbohydrate: dto.carbohydrate, fiber: dto.fiber, calcium: dto.calcium, ingredients: dto.ingredients)
        }
        cell.item = Item(_id: dto._id, name: dto.name, description: dto.description, image: image, isBookMarked: dto.isBookMarked, score: dto.score, calorie: dto.calorie, protein: dto.protein, fat: dto.fat, carbohydrate: dto.carbohydrate, fiber: dto.fiber, calcium: dto.calcium, ingredients: dto.ingredients)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let calcHeight = (height/5 + 10)
        return (calcHeight < 130) ? 130 : calcHeight
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let animator = CellAnimator().getAnimator(rowHeight: (height/4 + 10), duration: 0.85, delayFactor: 0.03)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func didPressCell(sender: Item){
        let recipeDetailView = RecipeDetailView()
        recipeDetailView.item = sender
        navigationController?.pushViewController(recipeDetailView, animated: true)
    }
    
    func goToLoginPress(){
        let refreshAlert = UIAlertController(title: "Alert", message: "Please login to add favourite", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.pushViewController(LoginView(), animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showToast(message: String){
        self.showToast(message: message, font: .systemFont(ofSize: 12.0))
    }
    
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginView(), animated: true)
    }
    
    @objc func cancelClicked() {
        self.searchBar.endEditing(true)
    }
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }
    
    // Set messages on empty tables.
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemGray
        messageLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    // Remove set messages before setting data.
    func restore() {
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
