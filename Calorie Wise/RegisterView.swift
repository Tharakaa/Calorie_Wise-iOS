//
//  RegisterView.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-01.
//

import UIKit

class RegisterView: UIViewController {
    
    let nameField = UITextField();
    let usernameField = UITextField()
    let passwordField = UITextField()
    let confPasswordField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // Validate inputs and shake invalid fields.
    @objc func registerClicked() {
        var isValid = true;
        if (!checkAndShake(field: nameField)) {isValid = false}
        if (!checkAndShake(field: usernameField)) {isValid = false}
        if (!checkAndShake(field: passwordField)) {isValid = false}
        if (!checkAndShake(field: confPasswordField)) {isValid = false}
        guard isValid else {
            return
        }
        
        let name = nameField.text
        let username = usernameField.text
        let password = passwordField.text
        let conFirmPassword = confPasswordField.text
        
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
        
        guard (password == conFirmPassword) else {
            passwordField.layer.borderWidth = 2
            passwordField.layer.cornerRadius = 6
            passwordField.layer.borderColor = UIColor.systemRed.cgColor
            confPasswordField.layer.borderWidth = 2
            confPasswordField.layer.cornerRadius = 6
            confPasswordField.layer.borderColor = UIColor.systemRed.cgColor
            let alert = UIAlertController(title: "Alert", message: "Passwords doesn't macth", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        passwordField.layer.borderWidth = 0
        confPasswordField.layer.borderWidth = 0
        
        let parameters: [String: String?] = ["name": name, "username": username, "password": password]
        let child = SpinnerViewController()
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        ApiCall.register(parameters: parameters){ (result) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            
            if (result == nil) {
                let errorAlert = UIAlertController(title: "Alert", message: "Error occurred when registering", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            if (result == 0) {
                let alert = UIAlertController(title: "Alert", message: "Account successfully created. Please login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else if (result == 1) {
                let alert = UIAlertController(title: "Alert", message: "Account already exist for given email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
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
    
    // Setup UI view and set constraints.
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let loginCardContainer = UIScrollView()
        loginCardContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginCardContainer)
        
        let loginCard = UIView()
        loginCard.translatesAutoresizingMaskIntoConstraints = false
        loginCardContainer.addSubview(loginCard)
        
        let logo = UIImageView(image: UIImage(named: "calorie_wise_logo"))
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        loginCard.addSubview(logo)
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Name"
        nameField.backgroundColor = .systemFill
        nameField.borderStyle = .roundedRect
        nameField.returnKeyType = UIReturnKeyType.next
        nameField.autocapitalizationType = UITextAutocapitalizationType.words
        nameField.keyboardType = UIKeyboardType.namePhonePad
        loginCard.addSubview(nameField)
        
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
        passwordField.returnKeyType = UIReturnKeyType.next
        loginCard.addSubview(passwordField)
        
        confPasswordField.translatesAutoresizingMaskIntoConstraints = false
        confPasswordField.placeholder = "Confirm Password"
        confPasswordField.isSecureTextEntry = true;
        confPasswordField.backgroundColor = .systemFill
        confPasswordField.borderStyle = .roundedRect
        confPasswordField.returnKeyType = UIReturnKeyType.done
        loginCard.addSubview(confPasswordField)
        
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 6
        registerButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerClicked), for: .touchUpInside)
        loginCard.addSubview(registerButton)
        
        let loginButton = UIButton()
        loginButton.setTitle("already have an account", for: .normal)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        loginCard.addSubview(loginButton)
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confPasswordField.delegate = self
        nameField.tag = 1
        usernameField.tag = 2
        passwordField.tag = 3
        confPasswordField.tag = 4
        
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
            
            nameField.heightAnchor.constraint(equalToConstant: 50),
            nameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            nameField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            usernameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            confPasswordField.heightAnchor.constraint(equalToConstant: 50),
            confPasswordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            confPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            confPasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registerButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            registerButton.heightAnchor.constraint(equalToConstant: 45),
            registerButton.topAnchor.constraint(equalTo: confPasswordField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 5),
            loginButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.85),
            loginButton.bottomAnchor.constraint(equalTo: loginCard.bottomAnchor, constant: -20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension RegisterView: UITextFieldDelegate {
    // Next button goes to the next field
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

