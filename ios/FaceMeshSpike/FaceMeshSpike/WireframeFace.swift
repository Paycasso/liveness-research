//
//  WireframeFace.swift
//  FaceMeshSpike
//
//  Created by Denis Silko on 22.02.2023.
//

import ARKit
import SceneKit

class WireframeFace: NSObject, VirtualContentController {

    var contentNode: SCNNode?
    var onlyFace: Bool = true
    var fullMesh: Bool = false
    
    init(onlyFace: Bool, fullMesh: Bool) {
        self.onlyFace = onlyFace
        self.fullMesh = fullMesh
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        faceGeometry.firstMaterial?.fillMode = fullMesh ? .fill : .lines
        let material = faceGeometry.firstMaterial!
        
        material.lightingModel = .physicallyBased
        
        contentNode = SCNNode(geometry: faceGeometry)
        
        if onlyFace {
            let bgNode = SCNNode(geometry: SCNPlane(width: 100, height: 100))
            bgNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            contentNode!.addChildNode(bgNode)
        }
    
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }

}
