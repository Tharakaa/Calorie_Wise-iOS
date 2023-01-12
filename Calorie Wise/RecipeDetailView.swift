//
//  RecipeDetailView.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-03.
//

import UIKit
import Lottie

class RecipeDetailView: UIViewController {

    let label = UILabel()
    let descriptionLabel = UILabel()
    var animationView = LottieAnimationView()
    //var imageObj = UIImage()
    var imageContainer = UIImageView()
    let container = UIView()
    var isBookMarked = false
    
    var recipe : Recipe? {
        didSet {
            print("XX")
            print(recipe?.name)
            let imageObj = recipe!.image
            imageContainer.image = imageObj
            container.addSubview(imageContainer)
            descriptionLabel.text = recipe?.smallDescription
            label.text = recipe?.name
            isBookMarked = ((recipe?.isBookMarked) == true)
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
                    self.recipe?.isBookMarked = false
                    self.isBookMarked = false
                    self.animationView.currentProgress = 0
                    ApiCall.removeBookmark(recipe: self.recipe!._id!){ () in
                        self.showToast(message: "Save Removed", font: .systemFont(ofSize: 12.0))
                    }
                })
            } else {
                animationView.play(fromProgress: 0, toProgress: 1, completion: {_ in
                    self.recipe?.isBookMarked = true
                    self.isBookMarked = true
                    self.animationView.currentProgress = 1
                    ApiCall.addBookmark(recipe: self.recipe!._id!){ () in
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
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title3)
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
        
        let calorieLabel = UILabel()
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieLabel.text = "356 calories"
        calorieLabel.numberOfLines = 0
        calorieLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        calorieLabel.adjustsFontForContentSizeCategory = true
        
        let fireIcon = UIImage(systemName: "flame")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let fireView = UIImageView(image: fireIcon)
        fireView.translatesAutoresizingMaskIntoConstraints = false
        fireView.contentMode = .scaleAspectFill
        fireView.clipsToBounds = true
        
        let mainScore = UILabel();
        mainScore.translatesAutoresizingMaskIntoConstraints = false
        mainScore.text = "8"
        mainScore.numberOfLines = 0
        mainScore.font = label.font.withSize(22)
        mainScore.adjustsFontForContentSizeCategory = true
        
        let scoreOutOf = UILabel();
        scoreOutOf.translatesAutoresizingMaskIntoConstraints = false
        scoreOutOf.text = "/10"
        scoreOutOf.numberOfLines = 0
        scoreOutOf.font = label.font.withSize(10)
        scoreOutOf.adjustsFontForContentSizeCategory = true
        
        let calorieContainer = UIView()
        calorieContainer.translatesAutoresizingMaskIntoConstraints = false
        calorieContainer.backgroundColor = .systemGray5
        calorieContainer.layer.cornerRadius = 14
        calorieContainer.addSubview(fireView)
        calorieContainer.addSubview(descriptionLabel)
        scrollView.addSubview(calorieContainer)
        
        let badgeContainer = UIView()
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.backgroundColor = .systemGreen
        badgeContainer.layer.cornerRadius = 10
        badgeContainer.addSubview(mainScore)
        badgeContainer.addSubview(scoreOutOf)
        scrollView.addSubview(badgeContainer)
        
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
            
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            calorieContainer.topAnchor.constraint(equalTo: fireView.topAnchor, constant: -4),
            calorieContainer.leftAnchor.constraint(equalTo: fireView.leftAnchor, constant: -5),
            calorieContainer.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: -2),
            calorieContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -5),
            fireView.rightAnchor.constraint(equalTo: calorieLabel.leftAnchor, constant: -3),
            fireView.bottomAnchor.constraint(equalTo: calorieContainer.bottomAnchor, constant: -3),
            calorieLabel.rightAnchor.constraint(equalTo: calorieContainer.rightAnchor, constant: -7),
            calorieLabel.bottomAnchor.constraint(equalTo: calorieContainer.bottomAnchor, constant: -6),
            
            badgeContainer.rightAnchor.constraint(equalTo: calorieContainer.rightAnchor, constant: -5),
            badgeContainer.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -1),
            badgeContainer.leftAnchor.constraint(equalTo: mainScore.leftAnchor, constant: -3),
            badgeContainer.topAnchor.constraint(equalTo: mainScore.topAnchor, constant: 0),
            scoreOutOf.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -3),
            scoreOutOf.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -3),
            mainScore.rightAnchor.constraint(equalTo: badgeContainer.rightAnchor, constant: -18),
            mainScore.bottomAnchor.constraint(equalTo: scoreOutOf.topAnchor, constant: 13),
            
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            animationView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -6),
            animationView.heightAnchor.constraint(equalToConstant: 60),
            animationView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func goToAccount() {
        navigationController?.pushViewController(AccountView(), animated: true)
    }

}
