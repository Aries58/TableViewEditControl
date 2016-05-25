//
//  MyTableViewCell.h
//  TableView多选删除
//
//  Created by 王亮 on 15/12/6.
//  Copyright © 2015年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTableViewCell;

@protocol MyTableViewCellDelegate

@optional
@property(nonatomic,readonly,getter=isStartEditing) BOOL startEdit;

-(void)selectCell:(MyTableViewCell *)cell;

@end

@interface MyTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,weak) id <MyTableViewCellDelegate> delegate;

@property(nonatomic,weak) UILabel *descLabel;

@end
