//
//  ViewController.swift
//  DataGridView
//
//  Created by 大工智博 on 2015/08/28.
//  Copyright (c) 2015年 medikaruno. All rights reserved.
//

import UIKit

class CustomGridTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let STATES_BAR_HEIGHT: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    
    static var staticTableView: UITableView = CustomUITableView()
    static var staticCols:Array<GridColumn> = Array()
    static var touchBeganCol:Int = 0
    var tableView:UITableView = CustomUITableView()
    var headerView: UIView = UIView()
    var cols:Array<GridColumn> = Array()
    var rows:Array<Dictionary<String,String>> = Array()//Dictionary<String,AnyObject>()
    var rowRenderer:(UITableViewCell?,Int)?// = (UITableViewCell,Int).self
    
    /**
    カスタマイズ項目
    oddBackgroundColor:奇数行の背景色
    headerHeihgt:ヘッダーの高さ
    cellHeight:Cellの高さ
    tblTouchDelegate(UILabel,UITouch):タッチされたセルに対するイベント
    */
    var oddBackgroundColor:UIColor = UIColor(red: 0, green: 0, blue: 50, alpha: 0.1)
    var headerHeihgt:CGFloat = 40
    var cellHeight:CGFloat = 45
    static var tableTouchDelegate:(UILabel,UITouch) -> () = {(touchedLabel:UILabel,touch:UITouch) -> () in
        touchedLabel.backgroundColor = UIColor.redColor()
    }
    static var tableViewTouchBegan:(UITouch) -> () = {(touch:UITouch) -> () in
        let location = touch.locationInView(CustomGridTableViewController.staticTableView)
        if let indexPath = CustomGridTableViewController.staticTableView.indexPathForRowAtPoint(location){
            CustomGridTableViewController.touchBeganCol = CustomGridTableViewController.getColumnIndex(Int(location.x))
        }
        CustomGridTableViewController.addTouchTableViewDelegate(touch)
    }
    static var tableViewTouchMove:(UITouch) -> () = {(touch:UITouch) -> () in
        CustomGridTableViewController.addTouchTableViewDelegate(touch)
    }
    static var tableViewTouchEnd:(UITouch) -> () = {(touch:UITouch) -> () in
        CustomGridTableViewController.addTouchTableViewDelegate(touch)
    }
    
    static func addTouchTableViewDelegate(touch:UITouch){
        let location = touch.locationInView(CustomGridTableViewController.staticTableView)
        if let indexPath = CustomGridTableViewController.staticTableView.indexPathForRowAtPoint(location){
            println(indexPath.row)
            var touchEndCol:Int = CustomGridTableViewController.getColumnIndex(Int(location.x))
            for (var i = 0; i <= touchEndCol - CustomGridTableViewController.touchBeganCol ; i++) {
                let touchMoveCol = CustomGridTableViewController.touchBeganCol + i
                if let label = CustomGridTableViewController.staticTableView.viewWithTag(touchMoveCol + (indexPath.row * 1000)) as? UILabel{
                    CustomGridTableViewController.tableTouchDelegate(label,touch)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面操作関連
        // タップを認識.
        let myTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        
        // スワイプ認識.
        let mySwipe = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        
        // スワイプ認識
        mySwipe.numberOfTouchesRequired = 2
        
        //tableView.addGestureRecognizer(myTap)
        //tableView.addGestureRecognizer(mySwipe)
        
        //tableView.
        var totalHeaderHeight = headerHeihgt + STATES_BAR_HEIGHT
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight //UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.userInteractionEnabled = true
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero;
        
        //sampleData
        rows.append(["id":"1","name":"大工　智博","tel":"090-9999-9999","5":"○"])
        rows.append(["id":"2","name":"山田　太郎","tel":"090-1234-5657","5":"○","6":"○","7":"○"])
        rows.append(["id":"3","name":"山田　太郎","tel":"090-9999-9999"])
        rows.append(["id":"4","name":"山田　太郎","tel":"090-9999-9999"])
        rows.append(["id":"5","name":"山田　太郎","tel":"090-9999-9999"])
        rows.append(["id":"6","name":"山田　太郎","tel":"090-9999-9999"])
        rows.append(["id":"7","name":"山田　太郎","tel":"090-9999-9999"])
        
        self.cols.append(GridColumn().initWithPropertyName("id",headerText: "ID",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("name",headerText: "名前",width: 100))
        self.cols.append(GridColumn().initWithPropertyName("tel",headerText: "電話番号",width: 120))
        self.cols.append(GridColumn().initWithPropertyName("1",headerText: "1",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("2",headerText: "2",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("3",headerText: "3",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("4",headerText: "4",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("5",headerText: "5",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("6",headerText: "6",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("7",headerText: "7",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("8",headerText: "8",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("9",headerText: "9",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("10",headerText: "10",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("11",headerText: "11",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("12",headerText: "11",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("13",headerText: "12",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("14",headerText: "13",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("15",headerText: "14",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("16",headerText: "15",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("17",headerText: "16",width: 40))
        self.cols.append(GridColumn().initWithPropertyName("18",headerText: "17",width: 40))
        
        
        self.view.backgroundColor = UIColor.grayColor()
        self.makeHeaderView()
        
        var tableFrame: CGRect = CGRectMake(0, totalHeaderHeight, self.view.bounds.size.width, self.view.bounds.size.height)
        self.tableView.frame = tableFrame
        self.view.addSubview(self.tableView)
        var bgView: UIView = UIView(frame: self.tableView.frame)
        bgView.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundView = bgView
        for var i = 0; i < self.cols.count; i++ {
            var right: Int = self.getLeftPosition(i + 1)
            var tableSeparator: UIView = UIView(frame: CGRectMake(CGFloat(right), 16, 1, CGFloat(self.tableView.bounds.size.height)))
            tableSeparator.backgroundColor = UIColor.lightGrayColor()
            self.tableView.backgroundView!.addSubview(tableSeparator)
        }
        CustomGridTableViewController.staticTableView = self.tableView
        CustomGridTableViewController.staticCols = self.cols
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    /*
    Cellに値を設定するデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId: String = "GridViewCell:\(indexPath.section)"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            var style: UITableViewCellStyle = UITableViewCellStyle.Default
            cell = UITableViewCell(style: style, reuseIdentifier: cellId)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.layoutMargins = UIEdgeInsetsZero
            if indexPath.row % 2 == 1{
                cell!.backgroundColor = oddBackgroundColor
            }
        }
        
        
        for view in cell!.contentView.subviews {
            view.removeFromSuperview()
        }
        
        if self.rowRenderer != nil {
            self.rowRenderer = (cell, indexPath.row)
        }
        var row: Dictionary = self.rows[indexPath.row]
        
        for var i = 0; i < self.cols.count; i++ {
            var col: GridColumn = self.cols[i]
            var left: Int = self.getLeftPosition(i)
            let leftAdd:CGFloat = CGFloat(left + 5)
            var label: UILabel = UILabel(frame: CGRectMake(CGFloat(left + 1), 0, CGFloat(col.width! - 1), cellHeight))
            if let str = row[col.propertyName!]{
                label.text = str
            }
            label.tag = i + (indexPath.row * 1000)
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.darkGrayColor()
            cell!.contentView.addSubview(label)
            var right: Int = self.getLeftPosition(i + 1)
            var separator: UIView = UIView(frame: CGRectMake(CGFloat(right), 0, 1, CGFloat(cell!.contentView.bounds.size.height)))
            separator.backgroundColor = UIColor.lightGrayColor()
            cell!.contentView.addSubview(separator)
        }
        
        return cell!
    }
    
    func makeHeaderView() {
        var totalHeaderHeight = headerHeihgt + STATES_BAR_HEIGHT
        
        self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.headerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        var headerFrame: CGRect = CGRectMake(0, 0, self.view.bounds.size.width, totalHeaderHeight)
        self.headerView.frame = headerFrame
        self.view.addSubview(self.headerView)
        
        var separatorTop: UIView = UIView(frame: CGRectMake(0, STATES_BAR_HEIGHT, CGFloat(self.headerView.bounds.size.width),1 ))
        separatorTop.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(separatorTop)
        
        for var i = 0; i < self.cols.count; i++ {
            var col: GridColumn = self.cols[i]
            var left: Int = self.getLeftPosition(i)
            var label: UILabel = UILabel(frame: CGRectMake(CGFloat(left + 1), STATES_BAR_HEIGHT, CGFloat(col.width! - 1), cellHeight))
            if let str = col.headerText{
                label.text = str
            }
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.darkGrayColor()
            self.headerView.addSubview(label)
            
            var right: Int = self.getLeftPosition(i + 1)
            var separator: UIView = UIView(frame: CGRectMake(CGFloat(right), STATES_BAR_HEIGHT, 1, CGFloat(self.headerView.bounds.size.height)))
            separator.backgroundColor = UIColor.lightGrayColor()
            self.headerView.addSubview(separator)
        }
        
        var bottomBorder: UIView = UIView(frame: CGRectMake(0, totalHeaderHeight - 1, self.headerView.bounds.size.width, 1))
        bottomBorder.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        bottomBorder.backgroundColor = UIColor.lightGrayColor()
        self.headerView.addSubview(bottomBorder)
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
    // 列のインデックスを取得
    static func getColumnIndex(widthPosition:Int) -> Int {
        var x:Int = 0
        for (var i = 0; i < CustomGridTableViewController.staticCols.count; i++) { //TODO: width:-1で可変幅列
            var col:GridColumn = CustomGridTableViewController.staticCols[i]
            if (widthPosition <= x) {
                return i - 1
            }
            x += col.width!
        } // その他の場合は、length+1として受け付ける
        return CustomGridTableViewController.staticCols.count - 1
    }
}


class CustomUITableView:UITableView{
    /**
    touchesBeganイベント
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // タッチイベントを取得.
        let touch = touches.first as! UITouch
        CustomGridTableViewController.tableViewTouchBegan(touch)
    }
    
    /**
    touchesEndedイベント
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        CustomGridTableViewController.tableViewTouchEnd(touch)
    }
    /**
    touchesMovedイベント
    */
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        CustomGridTableViewController.tableViewTouchMove(touch)
    }
}



