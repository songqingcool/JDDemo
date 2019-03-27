
//
//  JDFilesManagerController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/28.
//  Copyright © 2019 公司. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPageViewControllerScrollViweTag 20190120001

#import "JDFilesManagerController.h"
#import <Masonry/Masonry.h>
#import "JDFilesTitleCollectionViewCell.h"
#import "JDAllFilesViewController.h"
#import "JDOnlyFIlesViewController.h"
#import "JDOnlyImagesViewController.h"
#import "JDOnlyVediosViewController.h"

@interface JDFilesManagerController ()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout,
                                    UIPageViewControllerDelegate,
                                    UIPageViewControllerDataSource>

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UISegmentedControl *segmentedControl;
@property(nonatomic,strong)UICollectionView *typeCollectionView;
@property(nonatomic,strong)UIPageViewController *pageViewController;
@property(nonatomic,strong)NSArray *pageViewControllerArray;
@property(nonatomic,assign)NSInteger currentPageIndex;
@end

@implementation JDFilesManagerController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.view addSubview:self.typeCollectionView];
    [self addPageViewControllerToVC];
    
    [self.view setNeedsUpdateConstraints];
//    self.navigationItem.rightBarButtonItems

    // Do any additional setup after loading the view.
}

- (void)updateViewConstraints
{
    [self typeColletionViewLayoutConstraints];
    [self pageViewControllerLayoutConstraints];
    
    [super updateViewConstraints];
}

- (void)typeColletionViewLayoutConstraints
{
    [self.typeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
        
    }];
}

- (NSArray *)titleArray
{
    if(!_titleArray)
    {
        _titleArray = @[@"全部",@"文件",@"图片",@"视频",@"。。。"];
    }
    return _titleArray;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [self selectCollectionCell:_currentPageIndex];
}

#pragma mark - setupUI

-(UISegmentedControl *)segmentedControl
{
    if(!_segmentedControl)
    {
        NSArray *titleArray = @[@"文件",@"京盘"];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
        CGRect rect = CGRectMake(0, 0, 150, 30);
        _segmentedControl.frame = rect;
    }
    return _segmentedControl;
}

- (UICollectionView *)typeCollectionView
{
    if(!_typeCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _typeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _typeCollectionView.backgroundColor = [UIColor lightGrayColor];
        _typeCollectionView.dataSource = self;
        _typeCollectionView.delegate = self;
        _typeCollectionView.contentSize = CGSizeMake(kScreenWidth/4,0);
        _typeCollectionView.showsHorizontalScrollIndicator = NO;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        [_typeCollectionView registerClass:[JDFilesTitleCollectionViewCell class] forCellWithReuseIdentifier:@"JDFilesTitleCollectionViewCellIdentifier"];
    }
    return _typeCollectionView;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/4,collectionView.frame.size.height);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDFilesTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDFilesTitleCollectionViewCellIdentifier" forIndexPath:indexPath];
    [cell reloadModelData:@{@"title":self.titleArray[indexPath.row],@"index":[NSNumber numberWithInteger:indexPath.row]}];
    cell.typeClick = ^(NSInteger index)
    {
        [self turnPageWithIndex:index];
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDFilesTitleCollectionViewCell *cell = (JDFilesTitleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
     [cell reloadModelData:@{@"title":self.titleArray[indexPath.row],@"index":[NSNumber numberWithInteger:indexPath.row]}];
}

- (void)selectCollectionCell:(NSInteger)rowIndex
{
    if(self.typeCollectionView && [self.typeCollectionView respondsToSelector:@selector(selectItemAtIndexPath:animated:scrollPosition:)])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
        [self.typeCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        [self.typeCollectionView.delegate collectionView:self.typeCollectionView didSelectItemAtIndexPath:indexPath];
        [self.typeCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - UIPageViewControllerSetup
-(void)addPageViewControllerToVC
{
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)pageViewControllerLayoutConstraints
{
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeCollectionView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(UIPageViewController *)pageViewController
{
    if(!_pageViewController)
    {
        self.currentPageIndex = 0;
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        for (UIView *view in _pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delegate = self;
                view.tag = kPageViewControllerScrollViweTag;
                break;
            }
        }
        
        [_pageViewController setViewControllers:@[[self.pageViewControllerArray firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageViewController;
}

- (NSArray *)pageViewControllerArray
{
    if(!_pageViewControllerArray)
    {
        NSArray *viewControllerNamesArray = @[@"JDAllFilesViewController",
                                              @"JDOnlyFilesViewController",
                                              @"JDOnlyImagesViewController",
                                              @"JDOnlyVediosViewController"];
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSString *name in viewControllerNamesArray) {
            UIViewController *vc =[[NSClassFromString(name) alloc] init];
            [resultArray addObject:vc];
        }
        _pageViewControllerArray = [NSArray arrayWithArray:resultArray];
    }
    return _pageViewControllerArray;
}

#pragma mark - UIPageViewControllerDatasource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.pageViewControllerArray indexOfObject:viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self.pageViewControllerArray objectAtIndex:index];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.pageViewControllerArray indexOfObject:viewController];
    if (index == self.pageViewControllerArray.count - 1 || (index == NSNotFound)) {
        return nil;
    }
    index++;
    return [self.pageViewControllerArray objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)turnPageWithIndex:(NSInteger)index
{
    UIViewController *vc = [self.pageViewControllerArray objectAtIndex:index];
    if (index > self.currentPageIndex) {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        }];
    } else {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
            
        }];
    }
    self.currentPageIndex = index;
}

// 将要滑动
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    
}

// 结束滑动
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        UIViewController *nextVC = [pageViewController.viewControllers firstObject];
        NSInteger index = [self.pageViewControllerArray indexOfObject:nextVC];
        self.currentPageIndex = index;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == kPageViewControllerScrollViweTag)
    {
        if (self.currentPageIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        } else if (self.currentPageIndex == self.pageViewControllerArray.count-1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(scrollView.tag == kPageViewControllerScrollViweTag)
    {
        if (self.currentPageIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        } else if (self.currentPageIndex == self.pageViewControllerArray.count-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    }
}

@end
