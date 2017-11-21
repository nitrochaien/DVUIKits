//
//  MotionEffectViewController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 10/9/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

struct News: Decodable {
    var status_code: Int
    var message: String
    var users: [User]
}

struct User: Decodable {
    var name: String
    var password: String
    var profession: String
    var id: Int
}

class MotionEffectViewController: UIViewController {
    @IBOutlet var background: UIImageView!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyMotionEffect(toView: background, magnitude: 10)
        applyMotionEffect(toView: logo, magnitude: -20)
        
        getListUsers()
    }
    
    func applyMotionEffect(toView view: UIView, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    func getListUsers() {
        let jsonURLString = "http://127.0.0.1:8081/listUsers"
        guard let url = URL(string: jsonURLString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                if news.status_code == 0 {
                    print("Users: ", news.users)
                }
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
        }.resume()
    }
}
