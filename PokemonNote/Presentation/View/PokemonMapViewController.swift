//
//  PokemonMapViewController.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

class PokemonMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Life Cycle
    
    private var viewModel: PokemonMapViewModel!
    private let bag = DisposeBag()
    
    static func create(with viewModel: PokemonMapViewModel) -> PokemonMapViewController {
        let vc = PokemonMapViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    private func bindUI() {
        viewModel.locationSubject.subscribe { [weak self] (event: Event<[PokemonLocation]>) in
            guard let locations = event.element else { return }
            let annotationList = locations.map { (loc) -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude)
                return annotation
            }
            self?.mapView.addAnnotations(annotationList)
        }.disposed(by: bag)
    }
}
