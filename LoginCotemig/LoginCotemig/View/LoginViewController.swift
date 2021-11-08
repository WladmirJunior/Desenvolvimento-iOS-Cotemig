//
//  LoginViewController.swift
//  LoginCotemig
//
//  Created by Wladmir  on 07/11/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateLogin" {
            let viewController = segue.destination as! CreateUserViewController
            viewController.delegate = self
        }
    }
    
    @IBAction func loginApp(_ sender: Any) {
        guard checkFieldsFill(), let email = emailField.text, let pass = passField.text else {
            showDialog("Ops", message: "Preencha todas as informações!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
          guard let self = self else { return }
            
            if let error = error {
                self.handleError(error)
                return
            }
            
            self.performSegue(withIdentifier: "OpenHome", sender: nil)
        }
    }
    
    private func checkFieldsFill() -> Bool {
        return emailField.text != "" && passField.text  != ""
    }
    
    private func handleError(_ error: Error) {
        let createUserError = CreateUserError(rawValue: error.localizedDescription)
        switch createUserError {
        case .badFormat:
            showDialog("Ops", message: "O formato de email não é válido!")
        case .passwordInvalid, .userNotExist:
            showDialog("Ops", message: "Email ou senha inválidos!")
        default:
            showDialog("Ops", message: "Problema para acessar com a conta informada!")
        }
    }
}

extension LoginViewController: CreateUserViewControllerDelegate {
    func didCreateUser(createUserViewController: CreateUserViewController) {
        performSegue(withIdentifier: "OpenHome", sender: nil)
    }
}
