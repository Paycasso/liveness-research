//
//  VideoTexturedFace.swift
//  FaceMeshSpike
//
//  Created by Denis Silko on 22.02.2023.
//

import ARKit
import SceneKit

class VideoTexturedFace: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    var fillMesh: Bool = false
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
            let frame = sceneView.session.currentFrame,
            anchor is ARFaceAnchor
            else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: fillMesh)!
        let material = faceGeometry.firstMaterial!
        material.diffuse.contents = sceneView.scene.background.contents
        material.lightingModel = .constant

        guard let shaderURL = Bundle.main.url(forResource: "VideoTexturedFace", withExtension: "shader"),
            let modifier = try? String(contentsOf: shaderURL)
            else { fatalError("Can't load shader modifier from bundle.") }
        faceGeometry.shaderModifiers = [ .geometry: modifier]

        let affineTransform = frame.displayTransform(for: .portrait, viewportSize: sceneView.bounds.size)
        let transform = SCNMatrix4(affineTransform)
        faceGeometry.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
        
        contentNode = SCNNode(geometry: faceGeometry)
        
        let bgNode = SCNNode(geometry: SCNPlane(width: 100, height: 100))
        bgNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        contentNode!.addChildNode(bgNode)

        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
}
        
