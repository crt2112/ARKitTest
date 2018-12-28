//
//  PlaneNode.swift
//  ARKit_physicsBody
//
//  Created by beakhand on 2018/09/22.
//  Copyright © 2018年 beakhand. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

// 衝突カテゴリ
struct Category:OptionSet {
    let rawValue:Int
    static let planeCategory = Category(rawValue: 0b1 << 0)
    static let boxCategory =  Category(rawValue: 0b1 << 1)
}

class PlaneNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        // 平面のジオメトリを作る
        let planeHight:Float = 0.01
        let plane = SCNBox(width: CGFloat(anchor.extent.x), height: CGFloat(planeHight), length: CGFloat(anchor.extent.z), chamferRadius: 0.0)
        // 塗り（緑、半透明）
        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        // ワイヤーフレーム表示の分割数（ワイヤーフレームするかどうかはsceneViewで指定）
        plane.widthSegmentCount = 10
        plane.heightSegmentCount = 1
        plane.lengthSegmentCount = 10
        // ノードのgeometryプロパティに設定する
        geometry = plane
        // 位置決め
        position = SCNVector3Make(anchor.center.x, -planeHight, anchor.center.z)
        // 物理ボディを作る
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .static, shape: bodyShape)
        physicsBody?.friction = 3.0 // 摩擦
        physicsBody?.restitution = 0.2 // 反発力
        // 衝突する相手を決める
        physicsBody?.categoryBitMask = Int(Category.planeCategory.rawValue)  // 自身のカテゴリ
        physicsBody?.collisionBitMask = Int(Category.boxCategory.rawValue) // 衝突相手
    }
    
    // 位置とサイズを更新する
    func update(anchor: ARPlaneAnchor) {
        // ジオメトリを取り出す
        let plane = geometry as! SCNBox
        // アンカーから平面のサイズを更新する
        plane.width = CGFloat(anchor.extent.x)
        plane.length = CGFloat(anchor.extent.z)
        // 物理ボディの形を更新する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody?.physicsShape = bodyShape
        // 位置を更新する
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    }
}


