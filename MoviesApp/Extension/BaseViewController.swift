//
//  BaseViewController.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public func showAlert(title: String, message: String, completion: (() -> Void)? = nil, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okHandler?()
        }))
       
        present(alert, animated: true, completion: completion)
    }
}

extension Reactive where Base: BaseViewController{
    var failed: Binder<String>{
        return Binder(self.base) { view, result in
            view.showAlert(title: "Error", message: result)
        }
    }
}
