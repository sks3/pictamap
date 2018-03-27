//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var cameraButton: UIButton!
  
  let vc = UIImagePickerController()
  var pickedImage: UIImage!
  
  override func viewDidLoad() {
    
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                          MKCoordinateSpanMake(0.1, 0.1))
    mapView.setRegion(sfRegion, animated: false)
    mapView.delegate = self
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTapped(tapGesture:)))
    cameraButton.isUserInteractionEnabled = true
    cameraButton.addGestureRecognizer(tapGesture)
    vc.delegate = self
    vc.allowsEditing = true
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("Camera is available 📸")
      vc.sourceType = .camera
    } else {
      print("Camera 🚫 available so we will use photo library instead")
      vc.sourceType = .photoLibrary
    }
    
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    
    let nc = navigationController?.popToViewController(self, animated: true)
    
    let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = locationCoordinate
    annotation.title = "Picture!"
    mapView.addAnnotation(annotation)
    
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseID = "myAnnotationView"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
    if (annotationView == nil) {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
    }
    
    let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
    imageView.image = UIImage(named: "camera")
    
    return annotationView
  }
  
  @objc func cameraTapped(tapGesture: UITapGestureRecognizer) {
    print("camera activated")
    self.present(vc, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    // Get the image captured by the UIImagePickerController
    pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    // Dismiss UIImagePickerController to go back to your original view controller
    dismiss(animated: true, completion: {self.performSegue(withIdentifier: "tagSegue", sender: nil)})
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tagSegue" {
      let locationsViewController = segue.destination as! LocationsViewController
      locationsViewController.delegate = self
    }
  }
  
}
