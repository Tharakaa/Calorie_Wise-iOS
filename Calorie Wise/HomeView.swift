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
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load saved user data.
        ApiCall.loadData()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
        tableView.delaysContentTouches = true
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
        
        let loginButton:UIBarButtonItem
        if (ApiCall.isLoggedIn()) {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.shield.checkmark.fill"), style: .plain, target: self, action: #selector(goToAccount))
        } else {
            loginButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(goToLogin))
        }
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goToSearch))
        self.navigationItem.rightBarButtonItems  = [loginButton, searchButton]
        
        // show loading screen until data is loaded
        setLoadingScreen()
        ApiCall.fetchCategories{ (categories) in
            self.removeLoadingScreen()
            if (categories == nil) {
                let alert = UIAlertController(title: "Alert", message: "Server is not responding at the moment. Please try again later.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
            self.categories = categories ?? []
            self.tableView.reloadData()
        }
    }
    
    // refresh UI if logged in.
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
    }
    
    // set table view cells with recieved data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCell
        
        let imageView = UIImage(named: "food-background.png")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        let categoryDto = self.categories[indexPath.row]
        
        ApiCall.fetchCategoryImage(path: categoryDto.imagePath){ (newImage) in
            cell.category = Category(id: categoryDto._id, name: categoryDto.name, image: newImage, fontColor: .white, maxCalorie: categoryDto.maxCalorie, minCalorie: categoryDto.minCalorie)
        }
        
        cell.category = Category(id: categoryDto._id, name: categoryDto.name, image: imageView!, fontColor: .label, maxCalorie: categoryDto.maxCalorie, minCalorie: categoryDto.minCalorie)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    // set height of each cell.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        return (height/4 + 10)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        let animator = CellAnimator().getAnimator(rowHeight: (height/4 + 10), duration: 0.85, delayFactor: 0.03)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func didPressCell(sender: Category){
        let nextPage = RecipeListView()
        nextPage.minCalorie = sender.minCalorie
        nextPage.maxCalorie = sender.maxCalorie
        nextPage.title = sender.name
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
    
    private func setLoadingScreen() {
        
        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = .label
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        // Adds text and spinner to the view
        loadingView.alpha = 0.6
        loadingView.translatesAutoresizingMaskIntoConstraints = false;
        loadingView.addSubview(spinner)
        tableView.addSubview(loadingView)
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingView.isHidden = true
    }
    
}

