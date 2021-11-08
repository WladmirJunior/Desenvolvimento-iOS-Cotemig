//
//  RecoverViewController.swift
//  LoginCotemig
//
//  Created by Wladmir  on 07/11/21.
//

import UIKit
import FirebaseAuth

class RecoverViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func finishScreen(_ email: String) {
        self.showDialog("Email enviado", message: "Se \(email) pertencer a um cadastro válido a solicitação para recupação de senha será enviada!", okAction: {
            self.dismiss(animated: true)
        })
    }
    
    @IBAction func send(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            showDialog("Ops", message: "Preencha seu email!")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleError(error, email: email)
                return
            }
            
            self.finishScreen(email)
        }
    }
    
    private func handleError(_ error: Error, email: String) {
        let createUserError = CreateUserError(rawValue: error.localizedDescription)
        switch createUserError {
        case .badFormat:
            showDialog("Ops", message: "O formato de email não é válido!")
        default:
            finishScreen(email)
        }
    }
}

extension UIViewController {
    
    func showDialog(_ title: String, message: String, okAction: (() -> Void)? = nil) {
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            okAction?()
        }))
        present(dialog, animated: true)
    }
}
