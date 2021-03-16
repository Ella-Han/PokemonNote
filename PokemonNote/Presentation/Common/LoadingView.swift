//
//  LoadingView.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import UIKit

public enum LoadingOption {
    case general(title: String)
}

final class LoadingView {
    fileprivate static var innerLoadingView: InnerLoadingView?
    fileprivate static var option: LoadingOption = .general(title: "loading...")
    
    public static func show(_ loadingOption: LoadingOption) {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            if let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 }).first?.windows
                .filter({ $0.isKeyWindow }).first, innerLoadingView == nil {
                let frame = UIScreen.main.bounds
                innerLoadingView = InnerLoadingView(frame: frame)
                innerLoadingView?.configure(loadingOption)
                option = loadingOption
                keyWindow.addSubview(innerLoadingView!)
            }
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            guard let innerLoadingView = innerLoadingView else { return }
            innerLoadingView.removeFromSuperview()
            self.innerLoadingView = nil
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            if innerLoadingView != nil {
                hide()
                show(option)
            }
        }
    }
}
