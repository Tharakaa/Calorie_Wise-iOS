//
//  LoginView.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-01.
//

import UIKit
import Lottie

// Login screen
class LoginView: UIViewController {
    
    let usernameField = UITextField()
    let passwordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    @objc func goToRegister() {
        navigationController?.pushViewController(RegisterView(), animated: true)
    }
    
    // validate input fields and shake invalid fields.
    @objc func loginClicked() {
        var isValid = true;
        if (!checkAndShake(field: usernameField)) {isValid = false}
        if (!checkAndShake(field: passwordField)) {isValid = false}
        guard isValid else {
            return
        }
        
        let username = usernameField.text
        let password = passwordField.text
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: username) else {
            usernameField.layer.borderWidth = 2
            usernameField.layer.cornerRadius = 6
            usernameField.layer.borderColor = UIColor.systemRed.cgColor
            let alert = UIAlertController(title: "Alert", message: "Please enter a valid email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let parameters: [String: String?] = ["username": username, "password": password]
        
        let child = SpinnerViewController()
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        ApiCall.login(parameters: parameters){ (result) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            if (result == nil) {
                let errorAlert = UIAlertController(title: "Alert", message: "Error occurred when loggin in", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            if (result == 0) {
                // on successful login go back to home
                self.navigationController?.popToRootViewController(animated: true)
            } else if (result == 1) {
                let alert = UIAlertController(title: "Alert", message: "Username or Password is incorrect. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Shake invalid fields
    func checkAndShake(field: UITextField) -> Bool {
        let fieldText = field.text
        if (fieldText == nil || fieldText!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            CellAnimator().shakeView(viewToShake: field)
            field.layer.borderWidth = 2
            field.layer.cornerRadius = 6
            field.layer.borderColor = UIColor.systemRed.cgColor
            return false
        } else {
            return true
        }
    }
    
    // Set ui elements and set UI constaints
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let loginCardContainer = UIScrollView()
        loginCardContainer.showsVerticalScrollIndicator = false
        loginCardContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginCardContainer)
        
        let loginCard = UIView()
        loginCard.translatesAutoresizingMaskIntoConstraints = false
        loginCardContainer.addSubview(loginCard)
        
        let logo = UIImageView(image: UIImage(named: "calorie_wise_logo"))
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        loginCard.addSubview(logo)
        
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Email"
        usernameField.backgroundColor = .systemFill
        usernameField.borderStyle = .roundedRect
        usernameField.returnKeyType = UIReturnKeyType.next
        usernameField.autocapitalizationType = UITextAutocapitalizationType.none
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        usernameField.keyboardType = UIKeyboardType.emailAddress
        loginCard.addSubview(usernameField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true;
        passwordField.backgroundColor = .systemFill
        passwordField.borderStyle = .roundedRect
        passwordField.returnKeyType = UIReturnKeyType.done
        loginCard.addSubview(passwordField)
        
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 6
        loginButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        
        loginCard.addSubview(loginButton)
        
        let registerButton = UIButton()
        registerButton.setTitle("create an account", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.layer.cornerRadius = 6
        registerButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        loginCard.addSubview(registerButton)
        
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 1
        passwordField.tag = 2
        
        NSLayoutConstraint.activate([
            loginCardContainer.topAnchor.constraint(equalTo: view.safeTopAnchor),
            loginCardContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginCardContainer.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            loginCardContainer.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            
            loginCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginCard.centerYAnchor.constraint(equalTo: loginCardContainer.centerYAnchor),
            loginCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            loginCard.bottomAnchor.constraint(equalTo: loginCardContainer.bottomAnchor),
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.topAnchor.constraint(equalTo: loginCard.topAnchor),
            
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            usernameField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 100),
            
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            
            loginButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            
            registerButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            registerButton.bottomAnchor.constraint(equalTo: loginCard.bottomAnchor, constant: -20)
        ])
    }
    
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 6
    }
}

