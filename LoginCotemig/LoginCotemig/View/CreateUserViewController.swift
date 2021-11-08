//
//  CreateUserViewController.swift
//  LoginCotemig
//
//  Created by Wladmir  on 07/11/21.
//

import UIKit
import FirebaseAuth

protocol CreateUserViewControllerDelegate: AnyObject {
    func didCreateUser(createUserViewController: CreateUserViewController)
}

enum CreateUserError: String, Error {
    case badFormat = "The email address is badly formatted."
    case alreadyUse = "The email address is already in use by another account."
    case passwordInvalid = "The password is invalid or the user does not have a password."
    case userNotExist = "There is no user record corresponding to this identifier. The user may have been deleted."
}

class CreateUserViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    
    public weak var delegate: CreateUserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createUser(_ sender: Any) {
        guard checkFieldsFill() else {
            showDialog("Ops", message: "Preencha todas as informações!")
            return
        }
        
        guard checkPasswordQuality() else {
            showDialog("Ops", message: "A senha precisa ter no mínimo 6 caracteres!")
            return
        }
        
        guard checkPasswordsMatch() else {
            showDialog("Ops", message: "As senhas não conferem!")
            return
        }
        
        let email = emailField.text!
        let password = pass1.text!
       
        createUserInFireBase(with: email, andPassword: password)
    }
    
    private func createUserInFireBase(with email: String, andPassword password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleError(error)
                return
            }
            
            self.showDialog("Sucesso!", message: "Sua conta foi criada!", okAction: { [weak self] in
                guard let self = self else { return }
                
                self.dismiss(animated: true)
                self.delegate?.didCreateUser(createUserViewController: self)
            })
        }
    }
    
    private func checkFieldsFill() -> Bool {
        return emailField.text != "" && pass1.text  != "" && pass2.text != ""
    }
    
    private func checkPasswordQuality() -> Bool {
        return pass1.text?.count ?? 0 >= 6
    }
    
    private func checkPasswordsMatch() -> Bool {
        return pass1.text == pass2.text
    }
    
    private func handleError(_ error: Error) {
        let createUserError = CreateUserError(rawValue: error.localizedDescription)
        switch createUserError {
        case .badFormat:
            showDialog("Ops", message: "O formato de email não é válido!")
        case .alreadyUse:
            showDialog("Ops", message: "Este email já está sendo usado por outra conta!")
        default:
            showDialog("Ops", message: "Erro ao criar conta!")
        }
    }
}
