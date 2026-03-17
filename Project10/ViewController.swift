//
//  ViewController.swift
//  Project10
//
//  Created by Lucas Macêdo on 13/03/26.
//

import UIKit
import PhotosUI

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    var people = [Person]()
    let defaults = UserDefaults.standard
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: Person.self, from: savedPeople) {
                people = decodedPeople
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .prominent,
            target: self,
            action: #selector(addNewPerson)
        )
        
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "Person")
    }
    
    @objc func addNewPerson() {
        #if targetEnvironment(simulator)
            var pickerConfiguration = PHPickerConfiguration()
            pickerConfiguration.filter = .images
            pickerConfiguration.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: pickerConfiguration)
            picker.delegate = self
            
            present(picker, animated: true)
        #else
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                
                present(picker, animated: true)
            }
        #endif
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    
                    let imageName = UUID().uuidString
                    let imagePath = self?.getDocumentsDirectory().appendingPathComponent(imageName)
                    
                    if let imagePath, let jpegData = image.jpegData(compressionQuality: 0.8) {
                        try? jpegData.write(to: imagePath)
                    }
                    
                    let person = Person(name: "Unknown", image: imageName)
                    self?.people.append(person)
                    self?.collectionView.reloadData()
                    self?.save()
                }
            }
        }
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: true) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.personNameView.text = person.name
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.personImageView.image = UIImage(contentsOfFile: imagePath.path)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let selectActionAC = UIAlertController(title: "Select action", message: nil, preferredStyle: .actionSheet)
        
        selectActionAC.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Renaming person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                
                self?.collectionView.reloadItems(at: [indexPath])
                self?.save()
            })
            
            self?.present(ac, animated: true)
        })
        
        selectActionAC.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
            self?.save()
        })
        
        selectActionAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(selectActionAC, animated: true)
    }
}
