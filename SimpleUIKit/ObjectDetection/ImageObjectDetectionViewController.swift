/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreML
import Vision

class ImageObjectDetectionViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var scene: UIImageView!
  @IBOutlet weak var answerLabel: UILabel!

  // MARK: - Properties
  let vowels: [Character] = ["a", "e", "i", "o", "u"]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - IBActions
extension ImageObjectDetectionViewController {

  @IBAction func pickImage(_ sender: Any) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = .savedPhotosAlbum
    present(pickerController, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ImageObjectDetectionViewController: UIImagePickerControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    dismiss(animated: true)

    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      fatalError("couldn't load image from Photos")
    }

    scene.image = image
    
    guard let ciImage = CIImage(image: image) else { return }
    detectScene(ciImage)
  }
}

// MARK: - UINavigationControllerDelegate
extension ImageObjectDetectionViewController: UINavigationControllerDelegate {
  func detectScene(_ image: CIImage) {
    answerLabel.text = "Detecting Scene..."
    
    if #available(iOS 11.0, *) {
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let results = req.results as? [VNClassificationObservation], let topResult = results.first else { return }
            let article = self.vowels.contains(topResult.identifier.first!) ? "an" : "a"
            DispatchQueue.main.async {
                self.answerLabel.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
            }
        }
        
        try? VNImageRequestHandler(ciImage: image, options: [:]).perform([request])
    } else {
        // Fallback on earlier versions
    }
  }
}
