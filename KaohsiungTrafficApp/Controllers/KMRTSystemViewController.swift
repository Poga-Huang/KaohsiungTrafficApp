//
//  KMRTSystemViewController.swift
//  KaohsiungTrafficApp
//
//  Created by 黃柏嘉 on 2022/2/19.
//

import UIKit

class KMRTSystemViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var zoomScrollView: UIScrollView!
    @IBOutlet weak var kmrtSystemImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateZoom()
        
    }
    
    func updateContent(){
        guard let imageHeight = kmrtSystemImageView.image?.size.height else{return}
        let inset = (zoomScrollView.bounds.height-imageHeight*zoomScrollView.zoomScale)/2
        zoomScrollView.contentInset = .init(top: max(inset,0), left: 0, bottom: 0, right: 0)
    }
    
    func updateZoom(){
        zoomScrollView.zoomScale = 1
        zoomScrollView.minimumZoomScale = 1
        zoomScrollView.maximumZoomScale = 5
        updateContent()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        kmrtSystemImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContent()
    }
    
}
