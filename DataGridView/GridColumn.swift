//
//  GridColumn.swift
//  DataGridView
//
//  Created by 大工智博 on 2015/08/28.
//  Copyright (c) 2015年 medikaruno. All rights reserved.
//

import Foundation

class GridColumn : NSObject{
    var width:Int?
    var propertyName:String?
    var headerText:String?
    
    func initWithPropertyName(propertyName: String, headerText: String, width: Int) -> GridColumn {
        self.propertyName = propertyName
        self.headerText = headerText
        self.width = width
        return self
    }
}