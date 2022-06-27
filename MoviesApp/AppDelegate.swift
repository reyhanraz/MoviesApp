//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let _disposeBag = DisposeBag()
    var preference = Preference()


    lazy var tokenViewModel = ViewModel(service: RequestTokenAPI())
    lazy var sessionViewmodel = ViewModel(service: CreateSessionAPI())

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        binding()
        
        tokenViewModel.execute(request: Request())
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func binding(){
        tokenViewModel.result.drive(onNext: { result in
            guard let requestToken = result.request_token else { return }
            self.preference.requestToken = result.request_token
            self.sessionViewmodel.execute(request: CreateSessionRequest(request_token: requestToken))
        }).disposed(by: _disposeBag)
        
        sessionViewmodel.result.drive(onNext: { result in
            self.preference.sessionID = result.session_id
        }).disposed(by: _disposeBag)
    }


}

