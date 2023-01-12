//
//  HomeView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

class HomeView: UITableViewController, CategoryDelegate {
    
    let cellId = "cellCat"
    var categories: [CategoryDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall.loadData()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        //view.backgroundColor = .systemBackground
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
        tableView.delaysContentTouches = true
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
        //tableView.isHidden = true
        
        let loginButton:UIBarButtonItem
        if (ApiCall.isLoggedIn()) {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.shield.checkmark.fill"), style: .plain, target: self, action: #selector(goToAccount))
        } else {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(goToLogin))
        }
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goToSearch))
        self.navigationItem.rightBarButtonItems  = [loginButton, searchButton]
        
        ApiCall.fetchCategories{ (categories) in
            self.categories = categories ?? []
            
            //UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCurlDown, animations: {self.tableView.reloadData()}, completion: nil)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loginButton:UIBarButtonItem
        if (ApiCall.isLoggedIn()) {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.shield.checkmark.fill"), style: .plain, target: self, action: #selector(goToAccount))
        } else {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(goToLogin))
        }
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goToSearch))
        self.navigationItem.rightBarButtonItems  = [loginButton, searchButton]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCell
        
        let imageView = UIImage(named: "food-background.png")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        //imageView.loadFrom(URLAddress: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")
        
        let categoryDto = self.categories[indexPath.row]
        
        ApiCall.fetchCategoryImage(path: categoryDto.imagePath){ (newImage) in
            cell.category = Category(id: categoryDto._id, name: categoryDto.name, image: newImage, fontColor: .white)
        }
        
        cell.category = Category(id: categoryDto._id, name: categoryDto.name, image: imageView!, fontColor: .label)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        return (height/4 + 10)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let animator = CellAnimator().getAnimator(rowHeight: (height/4 + 10), duration: 0.85, delayFactor: 0.03)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func didPressCell(sender: String){
        print(sender)
        var category:CategoryDTO?;
        for cat in categories {
            if (cat._id == sender) {
                category = cat
                break
            }
        }
        let nextPage = RecipeListView()
        nextPage.catId = category!._id
        nextPage.title = category!.name
        navigationController?.pushViewController(nextPage, animated: true)
    }
    
    @objc func goToSearch() {
        navigationController?.pushViewController(SearchListView(), animated: true)
    }
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginView(), animated: true)
    }
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }
    
}

