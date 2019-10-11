//
//  Notes Model.swift
//  Organizer
//
//  Created by Вадим on 20/09/2019.
//  Copyright © 2019 Вадим. All rights reserved.
//

import Foundation

var noteIndex: Int?                  // Индекс открытой заметки
var isNewNote = false                // Если true, то вместо пустого заголовка в открытой заметке выводится "New Note"
var notes: [[String: String]] {      // Массив с заметками
    get {
        if let array = UserDefaults.standard.array(forKey: "NotesArray") {
            return array as! [[String : String]] 
        } else {
            return []
        }
    }
    
    set {
        UserDefaults.standard.set(newValue, forKey: "NotesArray")
        UserDefaults.standard.synchronize()
    }
}

func deleteNote (at index: Int) {                                 // Удаление заметки из массива
    notes.remove(at: index)
}

func changeOrder (from: Int, to: Int) {                           // Свап двух заметок
    let hold = notes[from]
    notes.remove(at: from)
    notes.insert(hold, at: to)
}

func updateNote(at index: Int, title: String, content: String) {  // Сохранение изменённой заметки в массив
    notes[index]["title"] = title
    notes[index]["content"] = content
}

func addNote() {                                                  // Добавление новой заметки в массив
    isNewNote = true
    noteIndex = 0
    let newNote = ["title": "", "content": ""]
    notes.insert(newNote, at: 0)
}

extension String {                                                // Проверка на наполненность строки без пробелов
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

