//
//  RegisterView.swift
//  Cook Book
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
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
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let loginCard = UIView()
        loginCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginCard)
        
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
//        registerButton.configuration = .filled()
//        registerButton.configuration?.baseBackgroundColor = .systemBlue
//        registerButton.configuration?.title = "Register"
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 6
        registerButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerClicked), for: .touchUpInside)
        loginCard.addSubview(registerButton)
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confPasswordField.delegate = self
        nameField.tag = 1
        usernameField.tag = 2
        passwordField.tag = 3
        confPasswordField.tag = 4
        
        NSLayoutConstraint.activate([
            loginCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginCard.heightAnchor.constraint(equalToConstant: 320),
            loginCard.widthAnchor.constraint(equalToConstant: 320),
            
            nameField.heightAnchor.constraint(equalToConstant: 50),
            nameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            nameField.centerYAnchor.constraint(equalTo: loginCard.centerYAnchor, constant: -125),
            nameField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            usernameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            usernameField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            confPasswordField.heightAnchor.constraint(equalToConstant: 50),
            confPasswordField.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            confPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            confPasswordField.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
            
            registerButton.widthAnchor.constraint(equalTo: loginCard.widthAnchor, multiplier: 0.9),
            registerButton.heightAnchor.constraint(equalToConstant: 45),
            registerButton.topAnchor.constraint(equalTo: confPasswordField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: loginCard.centerXAnchor),
        ])
    }

}

extension RegisterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
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
