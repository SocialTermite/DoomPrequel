//
//  DIContainer.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import Swinject

class DIContainer {
    private let container = Container()
    
    static let shared = DIContainer()
    
    private init() { }
    
    func registerDependencies() {
        registerApiLayer()
        registerCache()
        registerScreens()
    }
    
    func roverSelectionVC() -> RoverSelectionVC {
        let viewController = container.resolve(RoverSelectionVC.self)!
        let router = container.resolve(RoverSelectionRouter.self)!
        router.viewController = viewController
        return viewController
    }
    
    func photosVC(for rover: Rover) -> PhotosVC {
        let viewController = container.resolve(PhotosVC.self, argument: rover)!
        let router = photosRouter()
        router.viewController = viewController
        return viewController
    }
    
    func photosRouter() -> PhotosRouter {
        return container.resolve(PhotosRouter.self)!
    }
    
    private func registerApiLayer() {
        container.register(Serializer.self) { (resolver) in
            return NASASerializer()
        }.inObjectScope(.container)
        
        container.register(MarsRoverApi.self) { (resolver) in
            return NASARoverApi(serializer: resolver.resolve(Serializer.self)!)
        }.inObjectScope(.container)
        
        container.register(ApiClient.self) { (resolver) in
            return ApiClient(roverApi: resolver.resolve(MarsRoverApi.self)!)
        }.inObjectScope(.container)
    }
    
    private func registerCache() {
        container.register(UserCache.self) { _ in UserCache() }
    }
    
    private func registerScreens() {
        registerRoverSelectionVC()
        registerPhotosVC()
    }
    
    private func registerRoverSelectionVC() {
        container.register(RoverSelectionRouter.self) { _ in
            RoverSelectionRouter()
        }.inObjectScope(.container)
    
        
        container.register(PhotosRoute.self) { $0.resolve(RoverSelectionRouter.self)! }
        
        container.register(RoverSelectionVM.self) { resolver in
            return RoverSelectionVM(api: resolver.resolve(ApiClient.self)!,
                                    userCache: resolver.resolve(UserCache.self)!,
                                    photosRoute: resolver.resolve(PhotosRoute.self)!)
        }
        
        container.register(RoverSelectionVC.self) { resolver in
            return RoverSelectionVC(viewModel: resolver.resolve(RoverSelectionVM.self)!)
        }.inObjectScope(.container)
    }
    
    private func registerPhotosVC() {
        container.register(PhotosRouter.self) { _ in PhotosRouter() }.inObjectScope(.container)
        container.register(PhotosVM.self) { resolver, rover in
            return PhotosVM(api: resolver.resolve(ApiClient.self)!, userCache: resolver.resolve(UserCache.self)!, rover: rover, router: resolver.resolve(PhotosRouter.self)!)
        }
        
        let photosVCFactory: (Resolver, Rover) -> PhotosVC = { resolver, rover in
            return PhotosVC(viewModel: resolver.resolve(PhotosVM.self, argument: rover)!)
        }
        
        container.register(PhotosVC.self, factory: photosVCFactory)
    }
}
