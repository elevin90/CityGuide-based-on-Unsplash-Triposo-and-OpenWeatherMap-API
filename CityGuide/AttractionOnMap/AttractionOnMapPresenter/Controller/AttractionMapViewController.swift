//
//  AttractionMapViewController.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit
import MapKit

class AttractionMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private let presenter: AttractionOnMapPresenting
    
    init(with presenter: AttractionOnMapPresenting) {
        self.presenter = presenter
        super.init(nibName: "AttractionMapViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: presenter.attraction.location.latitude,
                                                 longitude:  presenter.attraction.location.longitude)
        annotation.title = presenter.attraction.title
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
