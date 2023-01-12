//
//  RecipeListView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit
import Lottie

class RecipeListView: UITableViewController, ListItemDelegate {
    
    let cellId = "CellId"
    var catId = "63b5c3ce0fdd6d2452f789ba"
    var recipes: [RecipeDTO] = []
    static var needToRefresh = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.register(ListItemCell.self, forCellReuseIdentifier: cellId)
        tableView.delaysContentTouches = true
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.dataSource = self
        
        if (ApiCall.isLoggedIn()) {
            let loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.shield.checkmark.fill"), style: .plain, target: self, action: #selector(goToAccount))
            self.navigationItem.rightBarButtonItem  = loginButton
        } else {
            let loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(goToLogin))
            self.navigationItem.rightBarButtonItem  = loginButton
        }
        
        ApiCall.fetchRecipesForCategory(category: catId){ (recipes) in
            self.recipes = recipes ?? []
            self.tableView.reloadData()
            RecipeListView.needToRefresh = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ApiCall.isLoggedIn()) {
            let loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.shield.checkmark.fill"), style: .plain, target: self, action: #selector(goToAccount))
            self.navigationItem.rightBarButtonItem  = loginButton
        } else {
            let loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(goToLogin))
            self.navigationItem.rightBarButtonItem  = loginButton
        }
        
        if (RecipeListView.needToRefresh) {
            ApiCall.fetchRecipesForCategory(category: catId){ (recipes) in
                self.recipes = recipes ?? []
                self.tableView.reloadData()
                RecipeListView.needToRefresh = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListItemCell
        let dto = self.recipes[indexPath.row]
        let image = (UIImage(systemName: "carrot")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))!
        ApiCall.fetchProductImage(path: dto.imagePath){ (newImage) in
            cell.recipe = Recipe(_id: dto._id, name: dto.name, smallDescription: dto.smallDescription, description: dto.description, image: newImage, isBookMarked: dto.isBookMarked)
        }
        cell.recipe = Recipe(_id: dto._id, name: dto.name, smallDescription: dto.smallDescription, description: dto.description, image: image, isBookMarked: dto.isBookMarked)
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
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let animator = CellAnimator().getAnimator(rowHeight: (height/4 + 10), duration: 0.85, delayFactor: 0.03)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func didPressCell(sender: Recipe){
        print(sender)
        
        let recipeDetailView = RecipeDetailView()
        recipeDetailView.recipe = sender
        navigationController?.pushViewController(recipeDetailView, animated: true)
    }
    
    func goToLoginPress(){
        let refreshAlert = UIAlertController(title: "Alert", message: "Please login to save recipe", preferredStyle: .alert)
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
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }
    
}
