//
//  Notes.swift
//  Organizer
//
//  Created by Вадим on 20/09/2019.
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

//MARK: Single Note Controller

class SingleNoteController: UIViewController {
    
    @IBOutlet weak var singleNoteContent: UITextView!    // Содержимое открытой заметки
    @IBOutlet weak var singleNoteTitle: UITextField!     // Заголовок открытой заметки
    @IBOutlet weak var titleHeight: NSLayoutConstraint!  // Высота поля для заголовка. Появляется в режиме редактирования. Иначе равна нулю
    @IBOutlet weak var editButton: UIBarButtonItem!      // Кнопка редактирования
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleNoteContent.text = notes[noteIndex!]["content"]!  // Определение содержимого
        singleNoteTitle.text = notes[noteIndex!]["title"]!      // Определение заголовка
        singleNoteContent.layer.cornerRadius = 10               // Радиус текстового поля заметки
        singleNoteContent.textContainerInset = .init(top: 15,   // Внутренние отступы текстового поля заметки
                                            left: 10, bottom: 80, right: 10)
        if !singleNoteTitle.text!.isBlank {                     // Определение заголовка в Navigation Bar
            self.title = singleNoteTitle.text!
        } else if isNewNote {
            self.title = "New Note"
            editSingleNoteAction(editButton)                        // Если новая заметка, то по-умолчанию открывается режим редактирования
        } else {
            self.title = singleNoteContent.text!
        }
        if isNewNote {
            
        }
        isNewNote = false
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(SingleNoteController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SingleNoteController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.textViewBottomConstraint.constant == -100 {
            self.textViewBottomConstraint.constant = keyboardFrame.height - 100
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.textViewBottomConstraint.constant != -100 {
            self.textViewBottomConstraint.constant = -100
        }
    }
    
    @IBAction func editSingleNoteAction(_ sender: UIBarButtonItem) {
        singleNoteContent.isEditable = !singleNoteContent.isEditable                          // Toggle для режима редактирования содержимого
        singleNoteContent.becomeFirstResponder()                                              // Для фокуса на текстовое поле и открытия клавиатуры
        singleNoteTitle.isUserInteractionEnabled = !singleNoteTitle.isUserInteractionEnabled  // Toggle для режима редактирования заголовка
        if singleNoteContent.isEditable {
            sender.title = "Done"
            sender.style = .done
            animateConstraint(constraint: titleHeight, to: 40, layout: self)                  // Плавное появление поля редактирования заголовка
            singleNoteTitle.isHidden = false
        } else {
            sender.title = "Edit"
            sender.style = .plain
            animateConstraint(constraint: titleHeight, to: 0, layout: self)                   // Плавное исчезновение поля редактирования заголовка
            singleNoteTitle.isHidden = true
            updateNote(at: noteIndex!, title: singleNoteTitle.text!,
                       content: singleNoteContent.text)                                       // Запись отредактированной заметки в массив
            if !singleNoteTitle.text!.isBlank {                                               /* Если отсутствует заголовок, в Navigation Bar
                                                                                                 отображается часть контента */
                self.title = singleNoteTitle.text!
            } else {
                self.title = singleNoteContent.text!
            }
        }
    }
        
}
