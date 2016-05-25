//
//  MyTableViewCell.m
//  TableView多选删除
//
//  Created by 王亮 on 15/12/6.
//  Copyright © 2015年 wangliang. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Masonry.h"

@interface MyTableViewCell ()

@property(nonatomic,getter=isStartEditing) BOOL startEdit;

@property(nonatomic,weak) UIView *mainView;

@property(nonatomic,weak) UIView *editControlView;

@property(nonatomic,weak) UIButton *editBtn;

@end

@implementation MyTableViewCell

static NSString * const ID=@"cell";
//static NSInteger const OffSetMarigin=42;

+(instancetype)cellWithTableView:(UITableView *)tableView{
 
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell=[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //添加控件
        [self setupView];
        
        //布局约束
        [self setupConstraints];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.editBtn.selected = selected;
}

-(void)setupView{
    
    //maimView
    UIView *mainView=[[UIView alloc] init];
    mainView.userInteractionEnabled=YES;
    [self.contentView addSubview:mainView];
    self.mainView=mainView;
    
    //editBtn
    UIButton *editBtn=[[UIButton alloc] init];
    
    [editBtn setImage:[UIImage imageNamed:@"editor_normal"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"editorBtn_highlighted"] forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(editBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:editBtn];
    self.editBtn=editBtn;
    
    //descLabel
    UILabel *descLabel=[[UILabel alloc] init];
    [mainView addSubview:descLabel];
    self.descLabel=descLabel;
}

-(void)setupConstraints{
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(-34);
        make.right.top.bottom.equalTo(self.contentView);
    }];
    
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //self.contentView.frame.size.height 值为44
        CGFloat editBtnY=(60 -25) * 0.5;
       
        make.left.equalTo(self.mainView.mas_left).offset(8);
        make.top.equalTo(self.mainView.mas_top).offset(editBtnY);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mainView.mas_left).offset(42);
        make.top.equalTo(self.mainView.mas_top).offset(5);
        make.bottom.equalTo(self.mainView.mas_bottom).offset(-5);
        make.right.equalTo(self.mainView.mas_right);
        
    }];
}


//button点击方法
-(void)editBtnDidClick:(UIButton *)button{
    
      //通知代理
    [self.delegate selectCell:self];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
 
    if ([self.delegate isStartEditing]) {
        
        self.startEdit=editing;
        
        [self beginEditMode];
        
    }else{
        
        [super setEditing:editing animated:animated];
    }
}

- (void)beginEditMode {
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        CGFloat newValue=self.isStartEditing ? 0 : -34;
        
        make.left.equalTo(self.contentView.mas_left).offset(newValue);
    }];
 
    //此方法貌似无用
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainView.superview layoutIfNeeded];
    }];
}

@end
