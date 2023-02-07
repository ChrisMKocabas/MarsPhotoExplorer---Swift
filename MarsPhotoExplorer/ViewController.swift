//
//  ViewController.swift
//  MarsPhotoExplorer
//
//  Created by Muhammed Kocabas on 2023-02-04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roverPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIDatePicker!
    @IBOutlet weak var numImages: UILabel!
    @IBOutlet weak var imagePicker: UIPickerView!
    @IBOutlet weak var roverImage: UIImageView!
    
    var photosResponseG : PhotosResponse?
    var selectedDay : String = "2015-06-03"
    let roversArray : [String] = ["Opportunity","Curiosity","Spirit"]
    var startDate : Date?
    var endDate  :Date?
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: Any, forEvent event: UIEvent) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateFormatter.string(from: self.dayPicker.date)
        let rover: String = roversArray[roverPicker.selectedRow(inComponent: 0)]
        selectedDay = date
        callAPI(rover: rover, date: selectedDay)
    
        let todaysDate = Date()
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateString = df.string(from: date)
        
         startDate = dateFormatter.date(from: "2004-07-23")
         endDate =  todaysDate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Connect data:
        self.imagePicker.delegate = self
        self.imagePicker.dataSource = self
 
        self.roverPicker.delegate = self
        self.roverPicker.dataSource = self
        
        dayPicker.minimumDate = startDate
        dayPicker.maximumDate = Date()
        
        callAPI(rover: roversArray[roverPicker.selectedRow(inComponent: 0)], date: selectedDay)
        
    }
    
    func callAPI(rover: String, date: String) {
        NetworkingService.shared.getData(rover: rover, date: date) { result in
            
            switch result{
            case .failure(let error):
                print(error)
                
            case .success(let data):
                let photosResponse : PhotosResponse =  JsonService.shared.parseWeatherJson(data: data)
                DispatchQueue.main.async {
                    
                    self.photosResponseG = photosResponse
                    
                    self.imagePicker.reloadAllComponents()
                    
                    
                    if (!(self.photosResponseG?.photos.isEmpty)!) {
                        let imageURL = self.photosResponseG?.photos[0].img_src
                        self.setImage(url: imageURL!)
                    }
                    else { self.roverImage.image = UIImage(named: "no-result")
                    }
                    

                }
            }
        }
    }
    
    func setImage(url: String) {
        
        NetworkingService.shared.loadImage (url: url) { result in
            switch result{
            case .failure(let error):
                print(error)
                
            case .success(let data):
                DispatchQueue.main.async {
                    
                    self.roverImage.image = UIImage(data: data)
                    self.roverImage.reloadInputViews()

                }
            }
        }
        
    }
    


}

extension ViewController:  UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
 
    return 1
    
}
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.restorationIdentifier == "idSelector" {
        guard let lastItem =  self.photosResponseG?.photos[row].id else {
            // do something else
            return "Loading"
        }
        return String(describing:lastItem )
    } else {
        return roversArray[row]
    }
    
}
func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView.restorationIdentifier == "idSelector" {
        let numberHolder = self.photosResponseG?.photos.count.codingKey.stringValue ?? "0"
        numImages.text = "Number of Images: \(numberHolder)"
        return self.photosResponseG?.photos.count ?? 1
        
    } else {
            return 3
        }
}
func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.restorationIdentifier == "idSelector" {
//        guard let imageURL = self.photosResponseG?.photos[row].img_src else {return}
//        setImage(url: imageURL)
        
        
        if (!(self.photosResponseG?.photos.isEmpty)!) {
            let imageURL = self.photosResponseG?.photos[row].img_src
            self.setImage(url: imageURL!)
        }
        else {
            self.roverImage.image = UIImage(named: "no-result")
        }
        
        
 
    } else {
        callAPI(rover: roversArray[row], date: selectedDay)
        }
}
    
    
    
    
}

