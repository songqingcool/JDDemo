
//
//  JDFileCollectionView.m
//  JDMail
//
//  Created by 千阳 on 2019/1/29.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDFileCollectionView.h"
#import "Cells/JDFileItemSelectCell.h"

#define kCollectionViewWidth  120

@interface JDFileCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation JDFileCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if(self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        [self registerClass:[JDFileItemSelectCell class] forCellWithReuseIdentifier:@"JDFileItemSelectCellIdentifier"];
        self.delegate = self;
        self.dataSource = self;
        self.allowsMultipleSelection = YES;
        self.isCollectonViewStyle = YES;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDFileItemSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDFileItemSelectCellIdentifier" forIndexPath:indexPath];
    
    CellLayoutType cellLayoutType = self.isCollectonViewStyle ?VerticalLayout: HorizontalLayout ;
    NSDictionary *model = @{@"fileName":@"abc.jpg",@"fileSize":@"16.8k",@"createTime":@"2018-09-10 20:08",@"imageUrl":@"",@"layoutType":[NSNumber numberWithInt:cellLayoutType]};
    
    cell.fileItemClickMore = ^(NSDictionary * _Nonnull modelDic) {
        
        [self clickCellMoreAction:model];
        
    };
    
    [cell reloadModelData:model];
    
    if(indexPath.row%2 == 1)
        cell.contentView.backgroundColor = [UIColor redColor];
    else
        cell.contentView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(self.isCollectonViewStyle)
    {
        size = CGSizeMake(kCollectionViewWidth, kCollectionViewWidth);
    }
    else
    {
        size = CGSizeMake(self.frame.size.width, 60);
    }
    return size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)clickCellMoreAction:(NSDictionary *)modelDic
{
    NSArray *paraArray = @[modelDic];
    self.collectionViewClickMoreAction(paraArray);
}
@end
