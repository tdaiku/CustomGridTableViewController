//
//  GridColumn.swift
//  DataGridView
//
//  Created by 大工智博 on 2015/08/28.
//  Copyright (c) 2015年 medikaruno. All rights reserved.
//

import Foundation
import UIKit

class GridColumn : NSObject{
    var width:Int?
    var propertyName:String?
    var headerText:String?
    var isTouched:Bool = false
    func initWithPropertyName(propertyName: String, headerText: String, width: Int) -> GridColumn {
        self.propertyName = propertyName
        self.headerText = headerText
        self.width = width
        return self
    }
}


enum SelectMode{
    case None
    case On
    case On2
    case Off
    case Off2
    case OnOff
    case TextInsert
    case TextDelete
}

class CustomUITableView:UITableView{
    static let STATES_BAR_HEIGHT: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    
    static var staticTableView: UITableView = CustomUITableView()
    static var staticCols:Array<GridColumn> = Array()
    static var touchBeganCol:Int = 0
    static var isTouched:Dictionary<String,Bool> = Dictionary()
    static var preCellIndexAtMoving = -1
    static var touchOffColIndex = 1
    static var selectMode:SelectMode = SelectMode.None
    
    
    var headerView: UIView = UIView()
    var cols:Array<GridColumn> = Array()
    var rows:Array<Dictionary<String,String>> = Array()//Dictionary<String,AnyObject>()
    
    /**
    カスタマイズ項目
    oddBackgroundColor:奇数行の背景色
    headerHeihgt:ヘッダーの高さ
    cellHeight:Cellの高さ
    tableTouchDelegateShowOnly(UILabel):セルをオンにした時にセルに対する変更を記述
    tableTouchOnDelegate(UILabel,UITouch):セルをオンにした時にデータに対する変更を記述
    */
    var EvenBackgroundColor:UIColor = UIColor(red: 0, green: 0, blue: 50, alpha: 0.1)
    var headerHeihgt:CGFloat = 40
    var cellHeight:CGFloat = 40
    var calWidth:Int = 30
    
    func initSetting(view:UIViewController){
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight //UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
        self.delegate = view as? UITableViewDelegate
        self.dataSource = view as? UITableViewDataSource
        self.allowsSelection = true
        self.userInteractionEnabled = true
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero;
        //self.scrollEnabled = false
    }
    
    
    /*
    設定されたColを元にヘッダーとTableViewを作成する
    */
    func makeHeaderAndTableView(uiViewController:UIViewController,tableView:CustomUITableView) {
        var totalHeaderHeight = headerHeihgt + CustomUITableView.STATES_BAR_HEIGHT
        
        self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.headerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        var headerFrame: CGRect = CGRectMake(0, 0, uiViewController.view.bounds.size.width, totalHeaderHeight)
        self.headerView.frame = headerFrame
        uiViewController.view.addSubview(self.headerView)
        
        var separatorTop: UIView = UIView(frame: CGRectMake(0, CustomUITableView.STATES_BAR_HEIGHT, CGFloat(self.headerView.bounds.size.width),1 ))
        separatorTop.backgroundColor = UIColor.lightGrayColor()
        uiViewController.view.addSubview(separatorTop)
        
        for var i = 0; i < self.cols.count; i++ {
            var col: GridColumn = self.cols[i]
            var left: Int = self.getLeftPosition(i)
            var label: UILabel = UILabel(frame: CGRectMake(CGFloat(left + 1), CustomUITableView.STATES_BAR_HEIGHT, CGFloat(col.width! - 1), headerHeihgt))
            if let str = col.headerText{
                label.text = str
            }
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.darkGrayColor()
            self.headerView.addSubview(label)
            
            var right: Int = self.getLeftPosition(i + 1)
            var separator: UIView = UIView(frame: CGRectMake(CGFloat(right), CustomUITableView.STATES_BAR_HEIGHT, 1, CGFloat(self.headerView.bounds.size.height)))
            separator.backgroundColor = UIColor.lightGrayColor()
            self.headerView.addSubview(separator)
        }
        
        var bottomBorder: UIView = UIView(frame: CGRectMake(0, totalHeaderHeight - 1, self.headerView.bounds.size.width, 1))
        bottomBorder.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        bottomBorder.backgroundColor = UIColor.lightGrayColor()
        self.headerView.addSubview(bottomBorder)
        
        
        var tableFrame: CGRect = CGRectMake(0, totalHeaderHeight, uiViewController.view.bounds.size.width, uiViewController.view.bounds.size.height)
        tableView.frame = tableFrame
        uiViewController.view.addSubview(tableView)
        
        var bgView: UIView = UIView(frame: tableView.frame)
        bgView.backgroundColor = UIColor.whiteColor()
        tableView.backgroundView = bgView
        for var i = 0; i < cols.count; i++ {
            var right: Int = tableView.getLeftPosition(i + 1)
            var tableSeparator: UIView = UIView(frame: CGRectMake(CGFloat(right), 0, 1, CGFloat(tableView.bounds.size.height)))
            if(i % 7 == CustomUITableView.touchOffColIndex){tableSeparator.backgroundColor = UIColor.yellowColor()
            }else{tableSeparator.backgroundColor = UIColor.lightGrayColor()}
            tableView.backgroundView!.addSubview(tableSeparator)
        }
        
        CustomUITableView.staticTableView = tableView
        CustomUITableView.staticCols = cols
    }
    
    /*
    設定されたColを元にAutoLayoutで設定しているヘッダーとTableViewを作成する
    */
    func makeHeaderAndTableViewAutoLayout(uiViewController:UIViewController,tableView:CustomUITableView,drawSpaceView:UIView) {
        
        //全画面じゃない場合はborder追加
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1
        
        let x = drawSpaceView.frame.origin.x
        let y = drawSpaceView.frame.origin.y
        let width = drawSpaceView.bounds.size.width
        let allHeight = drawSpaceView.bounds.size.height
        
        self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.headerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        var headerFrame: CGRect = CGRectMake(x, y ,width, headerHeihgt)
        self.headerView.frame = headerFrame
        uiViewController.view.addSubview(self.headerView)
        
        var separatorTop: UIView = UIView(frame: CGRectMake(x, y, CGFloat(width),1 ))
        separatorTop.backgroundColor = UIColor.lightGrayColor()
        uiViewController.view.addSubview(separatorTop)
        
        for var i = 0; i < self.cols.count; i++ {
            var col: GridColumn = self.cols[i]
            var left: Int = self.getLeftPosition(i)
            if(left + col.width!) > Int(width){break}
            var label: UILabel = UILabel(frame: CGRectMake(CGFloat(left + 1), 0, CGFloat(col.width! - 1), headerHeihgt))
            if let str = col.headerText{
                label.text = str
            }
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.darkGrayColor()
            self.headerView.addSubview(label)
            
            var right: Int = self.getLeftPosition(i + 1)
            var separator: UIView = UIView(frame: CGRectMake(CGFloat(right), 0, 1, CGFloat(headerHeihgt)))
            separator.backgroundColor = UIColor.lightGrayColor()
            self.headerView.addSubview(separator)
        }

        var leftBorder: UIView = UIView(frame: CGRectMake(0, 0, 1, headerHeihgt))
        leftBorder.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        leftBorder.backgroundColor = UIColor.lightGrayColor()
        self.headerView.addSubview(leftBorder)
        
        var rightBorder: UIView = UIView(frame: CGRectMake(width - 1, 0, 1, headerHeihgt))
        rightBorder.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        rightBorder.backgroundColor = UIColor.lightGrayColor()
        self.headerView.addSubview(rightBorder)
 
        
        var tableFrame: CGRect = CGRectMake(x, y + headerHeihgt, width, allHeight - headerHeihgt)
        tableView.frame = tableFrame
        uiViewController.view.addSubview(tableView)
        
        var bgView: UIView = UIView(frame: tableView.frame)
        bgView.backgroundColor = UIColor.whiteColor()
        tableView.backgroundView = bgView
        for var i = 0; i < cols.count; i++ {
            var right: Int = tableView.getLeftPosition(i + 1)
            var tableSeparator: UIView = UIView(frame: CGRectMake(CGFloat(right), 0, 1, CGFloat(allHeight - headerHeihgt)))
            //if(i % 7 == CustomUITableView.touchOffColIndex){tableSeparator.backgroundColor = UIColor.yellowColor()
            //}else{tableSeparator.backgroundColor = UIColor.lightGrayColor()}
            tableSeparator.backgroundColor = UIColor.lightGrayColor()
            tableView.backgroundView!.addSubview(tableSeparator)
        }
        
        CustomUITableView.staticTableView = tableView
        CustomUITableView.staticCols = cols
    }
    
    // 列の左端の座標を取得
    func getLeftPosition(colNumber:Int) -> Int {
        var x:Int = 0
        for (var i = 0; i < self.cols.count; i++) { //TODO: width:-1で可変幅列
            var col:GridColumn = self.cols[i]
            if (i == colNumber) {
                return x
            }
            x += col.width!
        } // その他の場合は、length+1として受け付ける
        return x
    }
    
    static var tableTouchOnDelegate:(UILabel,UITouch) -> () = {(touchedLabel:UILabel,touch:UITouch) -> () in
        tableTouchDelegateShowOnly(touchedLabel)
    }
    static var tableTouchOffDelegate:(UILabel,UITouch) -> () = {(touchedLabel:UILabel,touch:UITouch) -> () in
        touchedLabel.backgroundColor = UIColor.clearColor()
    }
    
    static var tableTouchDelegateShowOnly:(UILabel) -> () = {(touchedLabel:UILabel) -> () in
        touchedLabel.backgroundColor = UIColor.redColor()
    }
    
    static var tableViewTouchBegan:(UITouch) -> () = {(touch:UITouch) -> () in
        CustomUITableView.touchTableViewDelegate(touch)
    }
    static var tableViewTouchMove:(UITouch) -> () = {(touch:UITouch) -> () in
        CustomUITableView.touchmoveTableViewDelegate(touch)
    }
    static var tableViewTouchEnd:(UITouch) -> () = {(touch:UITouch) -> () in
        //CustomGridTableViewController.touchendTableViewDelegate(touch)
    }
    
    static func touchTableViewDelegate(touch:UITouch){
        let location = touch.locationInView(CustomUITableView.staticTableView)
        if let indexPath = CustomUITableView.staticTableView.indexPathForRowAtPoint(location){
            println(indexPath.row)
            var touchCol:Int = CustomUITableView.getColumnIndex(Int(location.x))
            if touchCol <= touchOffColIndex {return} //タッチ無効インデックス以下の場合は処理中止
            touchBeganCol = touchCol
            preCellIndexAtMoving = touchCol //moveイベントに入った時にtouchで処理したセルを処理しないようにする
            if let label = CustomUITableView.staticTableView.viewWithTag(touchCol + (indexPath.row * 1000)) as? UILabel{
                changeCellTouchedFlg(touchCol + (indexPath.row * 1000))
                if(CustomUITableView.getCellTouchedFlg(touchCol + (indexPath.row * 1000))){
                    CustomUITableView.tableTouchOnDelegate(label,touch)
                }else{
                    CustomUITableView.tableTouchOffDelegate(label,touch)
                }
            }
        }
    }
    
    
    static func touchmoveTableViewDelegate(touch:UITouch){
        let location = touch.locationInView(CustomUITableView.staticTableView)
        if let indexPath = CustomUITableView.staticTableView.indexPathForRowAtPoint(location){
            println(indexPath.row)
            var touchMovingCol:Int = CustomUITableView.getColumnIndex(Int(location.x))
            if touchMovingCol <= touchOffColIndex {return} //タッチ無効インデックス以下の場合は処理中止
            if preCellIndexAtMoving == touchMovingCol {return}    //前回と同じセルの場合は処理しない
            preCellIndexAtMoving = touchMovingCol
            if let label = CustomUITableView.staticTableView.viewWithTag(touchMovingCol + (indexPath.row * 1000)) as? UILabel{
                changeCellTouchedFlg(touchMovingCol + (indexPath.row * 1000))
                if(CustomUITableView.getCellTouchedFlg(touchMovingCol + (indexPath.row * 1000))){
                    CustomUITableView.tableTouchOnDelegate(label,touch)
                }else{
                    tableTouchOffDelegate(label,touch)
                }
            }
        }
    }
    
    /**
    セルの特定データがタッチされているかモードによってフラグを管理する
    SelectMode.On:タッチされたらTrue
    SelectMode.Off:タッチされたらFalse
    SelectMode.OnOff:タッチされたらTrue、Falseを切り替える
    SelectModeそれ以外：TODO
    */
    static func changeCellTouchedFlg(searchTag:Int){
        if selectMode == SelectMode.On{
            CustomUITableView.isTouched[searchTag.description] = true
            return
        }else if selectMode == SelectMode.Off{
            CustomUITableView.isTouched[searchTag.description] = false
            return
        }else if selectMode == SelectMode.None{
            return
        }
        
        if let existTagVal = CustomUITableView.isTouched[searchTag.description]{
            if(existTagVal == true){
                CustomUITableView.isTouched[searchTag.description] = false
            }else{
                CustomUITableView.isTouched[searchTag.description] = true
            }
        }else{
            CustomUITableView.isTouched[searchTag.description] = true
        }
    }
    
    
    // 列のインデックスを取得
    static func getColumnIndex(widthPosition:Int) -> Int {
        var x:Int = 0
        for (var i = 0; i < CustomUITableView.staticCols.count; i++) { //TODO: width:-1で可変幅列
            var col:GridColumn = CustomUITableView.staticCols[i]
            if (widthPosition <= x) {
                return i - 1
            }
            x += col.width!
        } // その他の場合は、length+1として受け付ける
        return CustomUITableView.staticCols.count - 1
    }
    
    
    /**
    セルの特定データがタッチされているかどうか
    */
    static func getCellTouchedFlg(searchTag:Int) -> Bool{
        if let existTagVal = CustomUITableView.isTouched[searchTag.description]{
            return existTagVal
        }else{
            return false
        }
    }
    
    /**
    touchesBeganイベント
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // タッチイベントを取得.
        let touch = touches.first as! UITouch
        CustomUITableView.tableViewTouchBegan(touch)
    }
    
    /**
    touchesEndedイベント
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        CustomUITableView.tableViewTouchEnd(touch)
    }
    /**
    touchesMovedイベント
    */
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        CustomUITableView.tableViewTouchMove(touch)
    }
}