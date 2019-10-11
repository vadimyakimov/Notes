//
//  Animations.swift
//  Organizer
//
//  Created by Вадим on 17/09/2019.
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

//MARK: Плавное изменение ограничений

func animateConstraint (constraint: NSLayoutConstraint, to value: CGFloat, layout: UIViewController) {
    UIView.animate(withDuration: 0.2) {
        constraint.constant = value
        layout.view.layoutIfNeeded()
    }
}
