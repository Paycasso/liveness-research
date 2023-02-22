//
//  VirtualContent.swift
//  FaceMeshSpike
//
//  Created by Denis Silko on 22.02.2023.
//

import ARKit
import SceneKit

enum VirtualContentType: Int {
    case wireframe
    case wireframeOnlyFace
    case wireframeFullMesh
    case videoTexture
    
    func makeController() -> VirtualContentController {
        switch self {
        case .wireframe:
            return WireframeFace(onlyFace: false, fullMesh: false)
        case .wireframeOnlyFace:
            return WireframeFace(onlyFace: true, fullMesh: false)
        case .wireframeFullMesh:
            return WireframeFace(onlyFace: true, fullMesh: true)
        case .videoTexture:
            return VideoTexturedFace()
        }
    }
}

protocol VirtualContentController: ARSCNViewDelegate {
    var contentNode: SCNNode? { get set }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
}
