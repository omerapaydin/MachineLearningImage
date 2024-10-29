

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func change(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        
        
        if let image = CIImage(image: imageView.image! ) {
            chosenImage = image
        }
        
        recognizerImage(image: chosenImage)
        
    }
    
    
    func recognizerImage(image: CIImage) {
        
        
        textLabel.text = "Analyzing..."
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    
                     let firstResult = results.first
                        
                    DispatchQueue.main.async {
                        
                        
                        let confidenlevel = (firstResult?.confidence ?? 0) * 100
                        
                        let rounded = Int(confidenlevel * 100) / 100
                        
                        self.textLabel.text = "\(rounded)% it's \(firstResult!.identifier)"
                        
                        
                        
                    }
                        
                    
                }
                
                
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do{
                    try handler.perform([request])
                }catch {
                    print("error")
                }
            }
            
            
        }
        
        
        
    }
    
    
    
}

