//
//  MyTableViewController.m
//  TableView多选删除
//
//  Created by 王亮 on 15/12/6.
//  Copyright © 2015年 wangliang. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"

@interface MyTableViewController ()<MyTableViewCellDelegate>

@property(nonatomic,getter=isStartEditing) BOOL startDelegateEdit;

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSMutableDictionary *editedDict;

@property(nonatomic,strong) UIView *backView;

@end

@implementation MyTableViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray=[NSMutableArray arrayWithObjects:@"圣诞节快乐01",@"圣诞节快乐02",@"圣诞节快乐03",@"圣诞节快乐04",@"圣诞节快乐05",@"圣诞节快乐06",@"圣诞节快乐07",@"圣诞节快乐08",@"圣诞节快乐09",@"圣诞节快乐10",@"圣诞节快乐11",@"圣诞节快乐12",@"圣诞节快乐13",nil];
    }
    return _dataArray;
}

-(NSMutableDictionary *)editedDict
{
    if (_editedDict == nil) {
        
        _editedDict=[NSMutableDictionary dictionary];
    }
    
    return _editedDict;
}

-(UIView *)backView
{
    if (_backView == nil) {
        
        _backView=[[UIView alloc] init];
        _backView.backgroundColor=[UIColor orangeColor];
    }
    
    return _backView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editDidClick)];;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    
    UIView *testView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *testBtn=[[UIButton alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
    [testBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [testBtn setTitle:@"全选" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    [testView addSubview:testBtn];

    self.navigationItem.titleView=testView;
    
    
    //此属性很关键
    self.tableView.allowsMultipleSelectionDuringEditing=YES;
}

-(void)selectAll{
    
    for (int i=0 ; i<self.dataArray.count; i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)delete{
    
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    
    [self.dataArray removeObjectsInArray:[self.editedDict allValues]];
    
    [self.tableView deleteRowsAtIndexPaths:[self.editedDict allKeys] withRowAnimation:UITableViewRowAnimationLeft];
    [self.editedDict removeAllObjects];
    [self.tableView reloadData];
    [self setEditing:NO animated:YES];
}

-(void)editDidClick{
    
    NSString *title = self.navigationItem.rightBarButtonItem.title;
 
    if ([title isEqualToString:@"编辑"]) {
        
        [self setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"取消";
   
    }else {
       
        [self setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    self.startDelegateEdit=YES;

    [super setEditing:editing animated:animated];
 }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell=[MyTableViewCell cellWithTableView:tableView];

    cell.descLabel.text=self.dataArray[indexPath.row];
    
    cell.delegate=self;
    
    //此句话作用
    [cell setEditing:self.isEditing];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//编辑行 缩进
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.editedDict setObject:[self.dataArray objectAtIndex:indexPath.row] forKey:indexPath];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.editedDict removeObjectForKey:indexPath];

}

#pragma mark -- MyTableViewCellDelegate
-(void)selectCell:(MyTableViewCell *)cell
{
    NSIndexPath *indexPath =  [self.tableView indexPathForCell:cell];
    UITableView *tableView=self.tableView;
    
    /*
       select/deselectRowAtIndexPath方法
       会屏蔽didSelect/didDeselectRowAtIndexPath方法调用需手动实现
     */
    
    if (cell.selected) {
       
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        if ([tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
            
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
        
    } else {
       
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

@end
