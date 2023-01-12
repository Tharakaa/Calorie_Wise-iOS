//
//  RecipeDetailView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-03.
//

import UIKit
import Lottie

class RecipeDetailView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let label = UILabel()
    let descriptionLabel = UILabel()
    let calorieLabel = UILabel()
    let mainScore = UILabel();
    let badgeContainer = UIView()
    var animationView = LottieAnimationView()
    //var imageObj = UIImage()
    var imageContainer = UIImageView()
    let container = UIView()
    var isBookMarked = false
    var messages: [String] = [String]()
    var nutriDataLabel: [String] = []
    var nutriDataValue: [String] = []
    
    var item : Item? {
        didSet {
            let imageObj = item!.image
            imageContainer.image = imageObj
            container.addSubview(imageContainer)
            descriptionLabel.text = item?.description
            calorieLabel.text = "\(item?.calorie ?? 0) calories"
            mainScore.text = "\(item?.score ?? 0)"
            if (item != nil && item!.score < 6) {
                badgeContainer.backgroundColor = .systemOrange
            } else if (item != nil && item!.score < 8) {
                badgeContainer.backgroundColor = .systemYellow
            } else {
                badgeContainer.backgroundColor = .systemGreen
            }
            
            nutriDataLabel.insert("Calorie", at: 0)
            nutriDataValue.insert("\(item?.calorie ?? 0) g", at: 0)
            nutriDataLabel.insert("Protein", at: 1)
            nutriDataValue.insert("\(item?.protein ?? 0) g", at: 1)
            nutriDataLabel.insert("Total Fat", at: 2)
            nutriDataValue.insert("\(item?.fat ?? 0) g", at: 2)
            nutriDataLabel.insert("Carbohydrate", at: 3)
            nutriDataValue.insert("\(item?.carbohydrate ?? 0) g", at: 3)
            nutriDataLabel.insert("Dietary Fiber", at: 4)
            nutriDataValue.insert("\(item?.fiber ?? 0) g", at: 4)
            nutriDataLabel.insert("Calcium", at: 5)
            nutriDataValue.insert("\(item?.calcium ?? 0) mg", at: 5)
            
            label.text = item?.name
            isBookMarked = ((item?.isBookMarked) == true)
            if (isBookMarked) {
                animationView.play(fromProgress: 0, toProgress: 1, completion: {_ in
                    self.animationView.currentProgress = 1
                })
            } else {
                animationView.play(fromProgress: 1, toProgress: 0, completion: {_ in
                    self.animationView.currentProgress = 0
                })
            }
            setupView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        setupView()
    }
    
    @objc func goToLogin() {
        navigationController?.pushViewController(LoginView(), animated: true)
    }
    
    @objc func bookmarkItem() {
        if (ApiCall.isLoggedIn()) {
            if (isBookMarked) {
                animationView.play(fromProgress: 1, toProgress: 0, completion: {_ in
                    self.item?.isBookMarked = false
                    self.isBookMarked = false
                    self.animationView.currentProgress = 0
                    ApiCall.removeBookmark(item: self.item!._id!){ () in
                        self.showToast(message: "Save Removed", font: .systemFont(ofSize: 12.0))
                    }
                })
            } else {
                animationView.play(fromProgress: 0, toProgress: 1, completion: {_ in
                    self.item?.isBookMarked = true
                    self.isBookMarked = true
                    self.animationView.currentProgress = 1
                    ApiCall.addBookmark(item: self.item!._id!){ () in
                        self.showToast(message: "Recipe Saved", font: .systemFont(ofSize: 12.0))
                    }
                })
            }
            RecipeListView.needToRefresh = true;
            BookmarkListView.needToRefresh = true;
        } else {
            let refreshAlert = UIAlertController(title: "Alert", message: "Please login to save recipe", preferredStyle: .alert)
            refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.pushViewController(LoginView(), animated: true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.contentMode = .scaleAspectFill
        imageContainer.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        //descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
        var bookmarkGesture: UITapGestureRecognizer!
        bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkItem))
        
        animationView = .init(name: "97064-bookmark-icon")
        animationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        animationView.contentMode = .scaleAspectFit
        animationView.currentProgress = 1
        animationView.animationSpeed = 1.25
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.addGestureRecognizer(bookmarkGesture)
        if (isBookMarked) {
            animationView.play(fromProgress: 0, toProgress: 1, completion: {_ in
                self.animationView.currentProgress = 1
            })
        } else {
            animationView.play(fromProgress: 1, toProgress: 0, completion: {_ in
                self.animationView.currentProgress = 0
            })
        }
        animationView.backgroundColor = .systemGray6
        animationView.layer.cornerRadius = 30
        
        let container = UIView();
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageContainer)
        container.addSubview(animationView)
        
        scrollView.addSubview(container)
        scrollView.addSubview(label)
        scrollView.addSubview(descriptionLabel)
        
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        //calorieLabel.text = "356 calories"
        calorieLabel.numberOfLines = 0
        calorieLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        calorieLabel.adjustsFontForContentSizeCategory = true
        
        let fireIcon = UIImage(systemName: "flame")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let fireView = UIImageView(image: fireIcon)
        fireView.translatesAutoresizingMaskIntoConstraints = false
        fireView.contentMode = .scaleAspectFill
        fireView.clipsToBounds = true
        
        mainScore.translatesAutoresizingMaskIntoConstraints = false
        //mainScore.text = "8"
        mainScore.numberOfLines = 0
        mainScore.font = label.font.withSize(22)
        
        let scoreOutOf = UILabel();
        scoreOutOf.translatesAutoresizingMaskIntoConstraints = false
        scoreOutOf.text = "/10"
        scoreOutOf.numberOfLines = 0
        scoreOutOf.font = label.font.withSize(10)

        
        let healthLabel = UILabel();
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        healthLabel.text = "Health Score :"
        healthLabel.numberOfLines = 0
        healthLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        calorieLabel.adjustsFontForContentSizeCategory = true
        scrollView.addSubview(healthLabel)
        
        let calorieContainer = UIView()
        calorieContainer.translatesAutoresizingMaskIntoConstraints = false
        calorieContainer.backgroundColor = .systemGray5
        calorieContainer.layer.cornerRadius = 14
        calorieContainer.addSubview(fireView)
        calorieContainer.addSubview(calorieLabel)
        scrollView.addSubview(calorieContainer)
        
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        //badgeContainer.backgroundColor = .systemGreen
        badgeContainer.layer.cornerRadius = 10
        badgeContainer.addSubview(mainScore)
        badgeContainer.addSubview(scoreOutOf)
        scrollView.addSubview(badgeContainer)
        
        let nutrionLabel = UILabel()
        nutrionLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrionLabel.text = "Nutrition Information"
        nutrionLabel.numberOfLines = 0
        nutrionLabel.font = .boldSystemFont(ofSize: 22)
        nutrionLabel.adjustsFontForContentSizeCategory = true
        scrollView.addSubview(nutrionLabel)
        
        let perServe = UILabel()
        perServe.translatesAutoresizingMaskIntoConstraints = false
        perServe.text = "(Per Serving)"
        perServe.numberOfLines = 0
        perServe.font = UIFont.preferredFont(forTextStyle: .caption1)
        perServe.adjustsFontForContentSizeCategory = true
        scrollView.addSubview(perServe)
        
        // Table view
        let nutrionTable = UITableView()
        nutrionTable.showsVerticalScrollIndicator = true
        nutrionTable.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        nutrionTable.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        nutrionTable.dataSource = self
        nutrionTable.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        nutrionTable.register(NutriCell.self, forCellReuseIdentifier: "nutriCell")
        nutrionTable.translatesAutoresizingMaskIntoConstraints = false;
        nutrionTable.isScrollEnabled = false
        nutrionTable.rowHeight = 45
        scrollView.addSubview(nutrionTable)
        
        let temp = UILabel();
        temp.text = "Details are based on taste.com.au"
        temp.font = UIFont.preferredFont(forTextStyle: .footnote)
        temp.translatesAutoresizingMaskIntoConstraints = false;
        temp.textAlignment = .center
        scrollView.addSubview(temp)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            container.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            imageContainer.widthAnchor.constraint(equalTo: container.widthAnchor),
            imageContainer.heightAnchor.constraint(equalTo: container.heightAnchor),
            imageContainer.topAnchor.constraint(equalTo: container.topAnchor),
            imageContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            animationView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -6),
            animationView.heightAnchor.constraint(equalToConstant: 60),
            animationView.widthAnchor.constraint(equalToConstant: 60),
            
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            badgeContainer.leftAnchor.constraint(equalTo: healthLabel.rightAnchor, constant: 5),
            badgeContainer.centerYAnchor.constraint(equalTo: healthLabel.centerYAnchor),
            badgeContainer.leftAnchor.constraint(equalTo: mainScore.leftAnchor, constant: -3),
            badgeContainer.topAnchor.constraint(equalTo: mainScore.topAnchor, constant: 0),
            scoreOutOf.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -3),
            scoreOutOf.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -3),
            mainScore.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -18),
            mainScore.bottomAnchor.constraint(equalTo: scoreOutOf.topAnchor, constant: 13),

            healthLabel.leftAnchor.constraint(equalTo: calorieContainer.rightAnchor, constant: 10),
            healthLabel.centerYAnchor.constraint(equalTo: calorieContainer.centerYAnchor),
            healthLabel.topAnchor.constraint(equalTo: calorieContainer.topAnchor),

            calorieContainer.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            calorieContainer.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -5),
            calorieContainer.bottomAnchor.constraint(equalTo: fireView.bottomAnchor, constant: 3),
            calorieContainer.rightAnchor.constraint(equalTo: calorieLabel.rightAnchor, constant: 5),
            //calorieContainer.rightAnchor.constraint(equalTo: healthLabel.leftAnchor, constant: -10),
            calorieLabel.leftAnchor.constraint(equalTo: fireView.rightAnchor, constant: 3),
            calorieLabel.centerYAnchor.constraint(equalTo: calorieContainer.centerYAnchor),
            fireView.leftAnchor.constraint(equalTo: calorieContainer.leftAnchor, constant: 5),
            fireView.centerYAnchor.constraint(equalTo: calorieContainer.centerYAnchor),
            fireView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            
            descriptionLabel.widthAnchor.constraint(equalTo: container.widthAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: calorieContainer.bottomAnchor, constant: 15),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
//            nutrionTable.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            
            //nutrionTable.bottomAnchor.constraint(equalTo: temp.topAnchor),
            
            nutrionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            nutrionLabel.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor),
            
            perServe.topAnchor.constraint(equalTo: nutrionLabel.bottomAnchor),
            perServe.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor),
            
            nutrionTable.topAnchor.constraint(equalTo: perServe.bottomAnchor, constant: 5),
            nutrionTable.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            nutrionTable.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            nutrionTable.heightAnchor.constraint(equalToConstant: 280),
            
            temp.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            temp.topAnchor.constraint(equalTo: nutrionTable.bottomAnchor),
            temp.leftAnchor.constraint(equalTo: nutrionTable.leftAnchor),
            temp.rightAnchor.constraint(equalTo: nutrionTable.rightAnchor),
            temp.centerXAnchor.constraint(equalTo: nutrionTable.centerXAnchor)
            
        ])
    }
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutriCell", for: indexPath) as! NutriCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.label.text = nutriDataLabel[indexPath.row]
        cell.descriptionLabel.text = nutriDataValue[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

}

class NutriCell: UITableViewCell {
    
    let label = UILabel()
    let descriptionLabel = UILabel()
    
//    var recipe : Recipe? {
//        didSet {
//            descriptionLabel.text = recipe?.smallDescription
//            label.text = recipe?.name
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Protein"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "356g"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .boldSystemFont(ofSize: 20)
        descriptionLabel.textAlignment = .right
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
        contentView.addSubview(label)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -45),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
