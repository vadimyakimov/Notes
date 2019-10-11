//
//  Notes.swift
//  Organizer
//
//  Created by Вадим on 20/09/2019.
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

//MARK: Notes Controller

class Notes: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = .init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if noteIndex != nil && notes[noteIndex!]["title"]!.isBlank  // Если при возвращении на главный экран в заметке не заполнены
            && notes[noteIndex!]["content"]!.isBlank {              // ни название, ни содержимое, она удаляется
            deleteNote(at: noteIndex!)
        }
        if notes.count > 0 {                                        // Placeholder при отсутствии заметок
            tableView.removeNoDataPlaceholder()
        } else {
            tableView.setNoDataPlaceholder("No notes here...")
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {                              // Количество секций
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // Количество строк
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        if notes[indexPath.row]["title"] != "" {                     // В заметке без заголовка вместо него выводится часть содержимого
            cell.textLabel?.text = notes[indexPath.row]["title"]
        } else {
            cell.textLabel?.text = notes[indexPath.row]["content"]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteIndex = indexPath.row   /* При выборе ячейки открывается редактор заметки.
                                       Для этого noteIndex записывает выделенную ячейку */
    }
     
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
        
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        changeOrder(from: fromIndexPath.row, to: to.row)
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {  // Режим редактирования на главном экране
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        if self.tableView.isEditing {
            sender.title = "Done"
            sender.style = .done
        } else {
            sender.title = "Edit"
            sender.style = .plain
        }
    }
    
    @IBAction func addAction(_ sender: Any) {  // Action для добавления новой заметки
        addNote()
        performSegue(withIdentifier: "newNoteController", sender: sender)
    }
    
}

//MARK: Placeholder для пустой таблицы

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.sizeToFit()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .gray

        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
