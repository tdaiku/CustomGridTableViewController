//
//  ViewController.swift
//  DataGridView
//
//  Created by 大工智博 on 2015/08/28.
//  Copyright (c) 2015年 medikaruno. All rights reserved.
//

import UIKit

class CustomGridTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:CustomUITableView = CustomUITableView()
    @IBOutlet weak var view_CustomTableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.initSetting(self)
        
        tableView.cols.append(GridColumn().initWithPropertyName("id",headerText: "ID",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("name",headerText: "名前",width: 80))
        tableView.cols.append(GridColumn().initWithPropertyName("1",headerText: "1",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("2",headerText: "2",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("3",headerText: "3",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("4",headerText: "4",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("5",headerText: "5",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("6",headerText: "6",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("7",headerText: "7",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("8",headerText: "8",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("9",headerText: "9",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("10",headerText: "10",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("11",headerText: "11",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("12",headerText: "12",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("13",headerText: "13",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("14",headerText: "14",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("15",headerText: "15",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("16",headerText: "16",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("17",headerText: "17",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("18",headerText: "18",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("19",headerText: "19",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("20",headerText: "20",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("21",headerText: "21",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("22",headerText: "22",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("23",headerText: "23",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("24",headerText: "24",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("25",headerText: "25",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("26",headerText: "26",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("27",headerText: "27",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("28",headerText: "28",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("29",headerText: "29",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("30",headerText: "30",width: tableView.calWidth))
        tableView.cols.append(GridColumn().initWithPropertyName("31",headerText: "31",width: tableView.calWidth))

        //sampleData
        tableView.rows.append(["id":"1","name":"大工　智博","tel":"090-9999-9999","5":"○"])
        tableView.rows.append(["id":"2","name":"山田　太郎","tel":"090-1234-5657","5":"○","6":"○","7":"○"])
        tableView.rows.append(["id":"3","name":"山田　太郎","tel":"090-9999-9999"])
        tableView.rows.append(["id":"4","name":"山田　太郎","tel":"090-9999-9999"])
        tableView.rows.append(["id":"5","name":"山田　太郎","tel":"090-9999-9999"])
        tableView.rows.append(["id":"6","name":"山田　太郎","tel":"090-9999-9999"])
        tableView.rows.append(["id":"7","name":"山田　太郎","tel":"090-9999-9999"])
        
        //self.tableView.makeHeaderAndTableView(self,tableView: tableView)
        self.tableView.makeHeaderAndTableViewAutoLayout(self,tableView: tableView,drawSpaceView:view_CustomTableView)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.cellHeight
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.rows.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId: String = "GridViewCell:\(indexPath.section)"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            var style: UITableViewCellStyle = UITableViewCellStyle.Default
            cell = UITableViewCell(style: style, reuseIdentifier: cellId)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.layoutMargins = UIEdgeInsetsZero
            if indexPath.row % 2 == 1{
                cell!.backgroundColor = self.tableView.EvenBackgroundColor
            }else{
                cell!.backgroundColor = UIColor.clearColor()
            }
        }
        
        
        for view in cell!.contentView.subviews {
            view.removeFromSuperview()
        }
        
        var row: Dictionary = self.tableView.rows[indexPath.row]
        
        for var i = 0; i < self.tableView.cols.count; i++ {
            var col: GridColumn = self.tableView.cols[i]
            var left: Int = self.tableView.getLeftPosition(i)
            let leftAdd:CGFloat = CGFloat(left + 5)
            var label: UILabel = UILabel(frame: CGRectMake(CGFloat(left + 1), 0, CGFloat(col.width! - 1), self.tableView.cellHeight))
            if let str = row[col.propertyName!]{
                label.text = str
            }
            label.tag = i + (indexPath.row * 1000)
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.darkGrayColor()
            cell!.contentView.addSubview(label)
            
            if(CustomUITableView.getCellTouchedFlg(label.tag)){
                CustomUITableView.tableTouchDelegateShowOnly(label)
            }
        }
        
        return cell!
    }
}




