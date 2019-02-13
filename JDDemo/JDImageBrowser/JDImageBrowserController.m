//
//  JDImageBrowserController.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/12/11.
//  Copyright © 2018 京东. All rights reserved.
//

#import "JDImageBrowserController.h"
#import "JDBrowserImageCell.h"
#import "JDImageModel.h"

@interface JDImageBrowserController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JDImageBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i< 10; i++) {
        JDImageModel *model = [[JDImageModel alloc] init];
        model.url = @"http://pic19.nipic.com/20120210/7827303_221233267358_2.jpg";
        [self.dataArray addObject:model];
    }
    self.collectionView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.collectionView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - getter & setter

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0.0;
        _flowLayout.minimumInteritemSpacing = 0.0;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JDBrowserImageCell class] forCellWithReuseIdentifier:@"JDBrowserImageCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDImageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    JDBrowserImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDBrowserImageCell" forIndexPath:indexPath];
    __weak JDImageBrowserController *weakSelf = self;
    cell.singleClickBlock = ^(JDImageModel *model) {
        __strong JDImageBrowserController *strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [cell reloadWithModel:model];
    return cell;
}

@end
