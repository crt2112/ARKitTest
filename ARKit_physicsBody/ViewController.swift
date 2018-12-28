//
//  ViewController.swift
//  ARKit_physicsBody
//
//  Created by beakhand on 2018/09/22.
//  Copyright © 2018年 beakhand. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fpsなどを表示する
        sceneView.showsStatistics = true
        // デリゲートになる
        sceneView.delegate = self
        // シーンを作る
        sceneView.scene = SCNScene()
        // ワイヤーフレーム表示
        sceneView.debugOptions = .showWireframe
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // コンフィグを作る
        let configuration = ARWorldTrackingConfiguration()
        // 平面の検出を有効化する（水平面）
        configuration.planeDetection = .horizontal
        // セッションを開始する
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セッションを止める
        sceneView.session.pause()
    }
    
    // シーンビューsceneViewをタップした
    @IBAction func tapSceneView(_ sender: UITapGestureRecognizer) {
        // タップしたARの座標
        let tapLoc = sender.location(in: sceneView)
        // 検知平面をタップしたか?
        let hitTestResult = sceneView.hitTest(tapLoc, types: .existingPlaneUsingExtent)
        // 検知平面をタップしたならば箱を追加する
        if let result = hitTestResult.first {
            // 箱を作って追加する
            let boxNode = BoxNode(hitTestResult: result)
            sceneView.scene.rootNode.addChildNode(boxNode)
        }
    }
    
    
    // MARK: - ARSCNViewDelegate
    // ノードが追加された
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 平面アンカーではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        // アンカーが示す位置に平面ノードを追加する
        node.addChildNode(PlaneNode(anchor: planeAnchor))
    }
    
    // ノードが更新された
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 平面アンカーではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        // PlaneNodeではないときは中断する
        guard let planeNode = node.childNodes.first as? PlaneNode else {
            return
        }
        // ノードの位置とサイズを更新する
        planeNode.update(anchor: planeAnchor)
    }
}


