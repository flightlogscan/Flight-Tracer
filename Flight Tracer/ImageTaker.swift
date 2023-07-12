//
//  CameraScanner.swift
//  Flight Tracer
//
//  Created by William Janis on 7/11/23.
//

import Foundation
import VisionKit
import SwiftUI

struct ImageTaker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isTakerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imageTaker = VNDocumentCameraViewController()
        imageTaker.delegate = context.coordinator
        return imageTaker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ImageTaker
        
        init(_ imageTaker: ImageTaker) {
            self.parent = imageTaker
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
            DispatchQueue.main.async {
                self.parent.selectedImage = scan.imageOfPage(at: 0)
            }
            
            parent.isTakerShowing = false
        }
    
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.isTakerShowing = false
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print(error.localizedDescription)
            parent.isTakerShowing = false
        }
    }
}


