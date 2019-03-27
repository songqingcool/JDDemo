
//
//  JDFileItemSelectCell.m
//  JDMail
//
//  Created by 千阳 on 2019/1/29.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDFileItemSelectCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface JDFileItemSelectCell()

@property(nonatomic,strong)UIImageView* thumbnailImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *sizeLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)UIButton *moreButton;

@end

@implementation JDFileItemSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.thumbnailImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.moreButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self thumbnailImageViewlayout:self.cellLayoutType];
    [self nameLabelLayout:self.cellLayoutType];
    [self sizeLabelLayout:self.cellLayoutType];
    [self timeLabelLayout:self.cellLayoutType];
    [self selectButtonLayout:self.cellLayoutType];
    [self moreButtonLayout:self.cellLayoutType];
    
}


- (void)thumbnailImageViewlayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/7*5);
    }
    else
    {
        rect = CGRectMake(0+self.selectButton.frame.size.width+20, (self.frame.size.height-36)/2, 36, 36);
    }
        
    
    self.thumbnailImageView.frame = rect;
}


- (UIImageView *)thumbnailImageView
{
    if(!_thumbnailImageView)
    {
        _thumbnailImageView = [[UIImageView alloc] init];
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548768970216&di=2aa941bbf40807f500df9a1e1c13fca7&imgtype=0&src=http%3A%2F%2Ftc.sinaimg.cn%2Fmaxwidth.2048%2Ftc.service.weibo.com%2Fp%2Fmmbiz_qpic_cn%2Ff524f49d7be5ec2d20fa0627a026d507.jpg"];
        [_thumbnailImageView sd_setImageWithURL:url placeholderImage:[UIImage new]];
    }
    return _thumbnailImageView;
}

- (void)nameLabelLayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(0, self.thumbnailImageView.frame.size.height, self.frame.size.width-24, self.frame.size.height/7);//高度7分之一。更多按钮宽24
    }
    else
    {
        CGRect selectButtonRect = self.selectButton.frame;
        CGRect iconRect = self.thumbnailImageView.frame;
        rect = CGRectMake(10+selectButtonRect.size.width+10+iconRect.size.width+10, iconRect.origin.y, 140, 20);
    }
    self.nameLabel.frame = rect;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:15];
        _nameLabel.font = font;
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

- (void)sizeLabelLayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(0, self.thumbnailImageView.frame.size.height+self.nameLabel.frame.size.height,self.frame.size.width/4, self.frame.size.height/7);//宽度4分之一
    }
    else
    {
        CGRect nameRect = self.nameLabel.frame;
        rect = CGRectMake(nameRect.origin.x, nameRect.origin.y+20, 140, 20);
    }
    self.sizeLabel.frame = rect;
}

- (UILabel *)sizeLabel
{
    if(!_sizeLabel)
    {
        _sizeLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:10];
        _sizeLabel.font = font;
        _sizeLabel.textColor = [UIColor lightGrayColor];
    }
    return _sizeLabel;
}

- (void)timeLabelLayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(self.frame.size.width/4, self.sizeLabel.frame.origin.y,self.frame.size.width/4*3, self.frame.size.height/7);
    }
    else
    {
        rect = CGRectMake(self.frame.size.width-self.timeLabel.frame.size.width, self.thumbnailImageView.frame.origin.y, 80, 20);
    }
    self.timeLabel.frame = rect;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:10];
        _timeLabel.font = font;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(void)selectButtonLayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(self.frame.size.width-24-5, self.thumbnailImageView.frame.size.height-24-10, 24, 24);
    }
    else
    {
        rect = CGRectMake(10, (self.frame.size.height-24)/2,24 , 24);
    }
    self.selectButton.frame = rect;
}

- (UIButton *)selectButton
{
    if(!_selectButton)
    {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setTitle:@"💣" forState:UIControlStateNormal];
        [_selectButton setTitle:@"💥" forState:UIControlStateSelected];
    }
    return _selectButton;
}

-(void)moreButtonLayout:(CellLayoutType)layoutType
{
    CGRect rect;
    if(layoutType == VerticalLayout)
    {
        rect = CGRectMake(self.nameLabel.frame.size.width, self.nameLabel.frame.origin.y, 24, self.nameLabel.frame.size.height);
    }
    else
    {
        rect = CGRectMake(self.frame.size.width-24, self.frame.size.height-24, 24, 24);
    }
    self.moreButton.frame = rect;
}

- (UIButton *)moreButton
{
    if(!_moreButton)
    {
        _moreButton = [[UIButton alloc] init];
        [_moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitle:@"🐱" forState:UIControlStateNormal];
    }
    return _moreButton;
}

- (void)reloadModelData:(NSDictionary *)modelDic
{
    /* @{@"fileName":@"abc.jpg",@"fileSize":@"16.8k",@"createTime":@"2018-09-10 20:08",@"imageUrl":@"",@"layoutType":[NSNumber numberWithInt:2]
     */
    NSString *fileName = modelDic[@"fileName"];
    NSString *fileSize = modelDic[@"fileSize"];
    NSString *time = modelDic[@"createTime"];
    CellLayoutType layoutType = (CellLayoutType)[modelDic[@"layoutType"] intValue];
//    self.thumbnailImageView.image =
    self.nameLabel.text = fileName;
    self.sizeLabel.text = fileSize;
    self.timeLabel.text = time;
    self.cellLayoutType = layoutType;
    
    [self setNeedsLayout];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectButton.selected = selected;
}

- (void)moreAction:(UIButton *)sender
{
    self.fileItemClickMore([NSDictionary new]);
}
@end
