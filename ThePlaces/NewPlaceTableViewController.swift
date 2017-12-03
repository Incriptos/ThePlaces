//
//  NewPlaceTableViewController.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 08.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var isVisited = false
    
    @IBAction func isVisitedButtonPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = true
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.8485872733, green: 0.06812975382, blue: 0.061535096, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isVisited = false
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || locationTextField.text == "" || typeTextField.text == "" {
            print("НЕ ВСЕ ПОЛЯ ЗАПОЛНЕНЫ")
            let alertController = UIAlertController(title: "Не все поля заполнены", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        } else {
            // добираюсь до контекста
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                // создаю экземпляр класса в контексте
                let place = Place(context: context)
                // устанавливаю значения для всех его свойств
                place.name = nameTextField.text
                place.location = locationTextField.text
                place.type = typeTextField.text
                place.isVisited = isVisited
                // преобразовую ПНГ в НСДату
                if let image = uploadImageView.image {
                    place.image = UIImagePNGRepresentation(image) //as NSData?
                }
                // если все прошло успешно, сохраняю контекст
                do {
                    try context.save()
                    print("Сохранение удалось!")
                } catch let error as NSError {
                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                }
                
            }
            performSegue(withIdentifier: "unwindSegueFromNewPlace", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yesButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        noButton.backgroundColor = #colorLiteral(red: 0.8485872733, green: 0.06812975382, blue: 0.061535096, alpha: 1)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        uploadImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alertController = UIAlertController(title: "Источник", message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .camera)
            })
            let photoLib = UIAlertAction(title: "Бибилиотека изображений", style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            })
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(camera)
            alertController.addAction(photoLib)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
            
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func chooseImagePickerAction (source: UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
   
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
