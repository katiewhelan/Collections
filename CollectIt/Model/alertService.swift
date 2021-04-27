//
//  alertService.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 3/2/21.
//

import UIKit

struct AlertService {
    
    
    func alert() -> AlertViewController {
        let sb = UIStoryboard(name: "Alert", bundle: .main)
        
        let alertVC = sb.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        return alertVC
    }
    
    
    
    
}

