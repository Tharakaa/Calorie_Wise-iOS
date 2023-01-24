//
//  BookmarkListView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit
import Lottie

// Table view for disaplying saved items for a user.
class BookmarkListView: UITableViewController, ListItemDelegate {
    
    let cellId = "favCellId"
    var catId = ""
    var items: [ItemDTO] = []
    static var needToRefresh = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        // register cell class with unique id.
        // This id is used to remove and reload table cells when necessary to conserve ram
        tableView.register(ListItemCell.self, forCellReuseIdentifier: cellId)
        tableView.delaysContentTouches = true
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        ApiCall.getBookmarkedForUser{ (recipes) in
            self.items = recipes ?? []
            self.tableView.reloadData()
            BookmarkListView.needToRefresh = false
        }
    }
    
    // Bookmarks can be set in details page. If changed a boolean flag is set
    // notifying that the view needs to be reloaded.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (BookmarkListView.needToRefresh) {
            ApiCall.getBookmarkedForUser{ (recipes) in
                self.items = recipes ?? []
                self.tableView.reloadData()
                BookmarkListView.needToRefresh = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Set cell items with received data. A seperate API request is sent to retrieve images.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListItemCell
        let dto = self.items[indexPath.row]
        let image = (UIImage(systemName: "carrot")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))!
        ApiCall.fetchProductImage(path: dto.imagePath){ (newImage) in
            cell.item = Item(_id: dto._id, name: dto.name, description: dto.description, image: newImage, isBookMarked: dto.isBookMarked, score: dto.score, calorie: dto.calorie, protein: dto.protein, fat: dto.fat, carbohydrate: dto.carbohydrate, fiber: dto.fiber, calcium: dto.calcium)
        }
        cell.item = Item(_id: dto._id, name: dto.name, description: dto.description, image: image, isBookMarked: dto.isBookMarked, score: dto.score, calorie: dto.calorie, protein: dto.protein, fat: dto.fat, carbohydrate: dto.carbohydrate, fiber: dto.fiber, calcium: dto.calcium)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let calcHeight = (height/5 + 10)
        return (calcHeight < 130) ? 130 : calcHeight
    }
    
    // set cell animations
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let animator = CellAnimator().getAnimator(rowHeight: (height/4 + 10), duration: 0.85, delayFactor: 0.03)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    // Capture cell taps.
    func didPressCell(sender: Item){
        let recipeDetailView = RecipeDetailView()
        recipeDetailView.item = sender
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
        ApiCall.getBookmarkedForUser{ (recipes) in
            self.items = recipes ?? []
            self.tableView.reloadData()
            BookmarkListView.needToRefresh = false
        }
    }
    
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginView(), animated: true)
    }
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }
    
}
