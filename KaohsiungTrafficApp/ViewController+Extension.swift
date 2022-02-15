//
//  ViewController+extension.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/14.
//

import Foundation
import UIKit

extension UIViewController{
    func displayError(completion:@escaping ()->()){
        let alert = UIAlertController(title: "下載失敗", message: "無法正常下載,請檢查網路狀態", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "重新整理", style: .default, handler: { _ in
            completion()
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    func remindAlert(title:String,message:String,completion:@escaping(UIAlertAction)->()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: { action in
            completion(action)
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
