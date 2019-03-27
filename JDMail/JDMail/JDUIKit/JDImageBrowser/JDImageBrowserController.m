//
//  JDImageBrowserController.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDImageBrowserController.h"
#import <Masonry/Masonry.h>
#import "JDImageAnimatedTransitionDataSource.h"
#import "JDBrowserCollectionViewCell.h"
#import "JDImageSourceModel.h"

@interface JDImageBrowserController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, JDImageAnimatedTransitionDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *pageNumberLabel;

@end

@implementation JDImageBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    //
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageNumberLabel];
    [self.view setNeedsUpdateConstraints];
    
    [self.collectionView reloadData];
    [self updateCurrentIndex:self.currentIndex];
    [self initLongPressAction];
}

- (void)updateViewConstraints
{
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.pageNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
        }
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(64.0);
    }];

    [super updateViewConstraints];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initLongPressAction
{
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureAction:)];
    [self.view addGestureRecognizer:longGesture];
}

- (void)longGestureAction:(UILongPressGestureRecognizer *)gesture
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout/UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDImageSourceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    JDBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDBrowserCollectionViewCell" forIndexPath:indexPath];
    __strong JDImageBrowserController *weakSelf = self;
    cell.tapClickBlock = ^(JDImageSourceModel *mo) {
        __strong JDImageBrowserController *strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [cell reloadWithModel:model];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    pageIndex += (scrollView.contentOffset.x - pageIndex * CGRectGetWidth(scrollView.frame)) / CGRectGetWidth(scrollView.frame) > 0.5 ? 1 : 0;
    NSLog(@"%@,%@",scrollView,self.collectionView);
    NSLog(@"%@,%@",NSStringFromCGPoint(scrollView.contentOffset),NSStringFromCGRect(scrollView.frame));
    [self updateCurrentIndex:pageIndex];
}

- (void)updateCurrentIndex:(NSInteger)index
{
    self.currentIndex = index;
    [self.view layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    NSString *text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentIndex + 1,(unsigned long)self.dataArray.count];
    self.pageNumberLabel.text = text;
}

#pragma mark - JDImageAnimatedTransitionDataSource

- (UIImageView *)animatedTransitionPresentViewControllerTapView
{
    return self.tapImageView;
}

- (void)animatedTransitionBeginPresentViewController
{
    self.collectionView.hidden = YES;
}

- (void)animatedTransitionEndPresentViewController
{
    self.collectionView.hidden = NO;
}

- (UIImageView *)animatedTransitionDismissViewControllerCurrentImageView
{
    JDBrowserCollectionViewCell *cell = (JDBrowserCollectionViewCell *)self.collectionView.visibleCells.firstObject;
    return [cell currentImageView];
}

- (void)animatedTransitionBeginDismissViewController
{
    self.collectionView.hidden = YES;
}

- (UIImageView *)animatedTransitionDismissViewControllerTargetView
{
    UIImageView *imageView = nil;
    if (self.dismissTargetViewBlock) {
        imageView = self.dismissTargetViewBlock(self.currentIndex);
    }
    return imageView;
}

#pragma mark - getter/setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JDBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"JDBrowserCollectionViewCell"];
    }
    return _collectionView;
}

- (UILabel *)pageNumberLabel
{
    if (!_pageNumberLabel) {
        _pageNumberLabel = [[UILabel alloc] init];
        _pageNumberLabel.font = [UIFont boldSystemFontOfSize:19.0];
        _pageNumberLabel.textColor = [UIColor whiteColor];
        _pageNumberLabel.textAlignment = NSTextAlignmentCenter;
        _pageNumberLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
    return _pageNumberLabel;
}

- (void)setDataArray:(NSArray<JDImageSourceModel *> *)dataArray
{
    _dataArray = dataArray;
    
    if (dataArray.count > 1) {
        self.pageNumberLabel.hidden = NO;
    }else{
        self.pageNumberLabel.hidden = YES;
    }
}

@end
