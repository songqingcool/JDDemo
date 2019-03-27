
//
//  JDFilesTitleCollectionViewCell.m
//  JDMail
//
//  Created by 千阳 on 2019/1/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDFilesTitleCollectionViewCell.h"

@interface JDFilesTitleCollectionViewCell()



@end

@implementation JDFilesTitleCollectionViewCell
{
    @private
    NSInteger currentIndex;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.titleButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self titleLabelLayout];
}

- (void)titleLabelLayout
{
    self.titleButton.frame = self.contentView.bounds;
}

- (UIButton *)titleButton
{
    if(!_titleButton)
    {
        _titleButton = [[UIButton alloc] init];
        [_titleButton addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    return _titleButton;
}


- (void)reloadModelData:(NSDictionary *)modelDic
{
    NSString *title = modelDic[@"title"];
    NSInteger index = [modelDic[@"index"] integerValue];
    if(title && title.length>0)
    {
        currentIndex = index;
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.titleButton setTitle:title forState:UIControlStateSelected];
    }
    NSLog(@"title is %@",title);
}


- (void)titleAction:(UIButton *)sender
{
    self.typeClick(currentIndex);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.titleButton.selected = selected;
}
@end
