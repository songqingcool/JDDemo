//
//  JDFloatIndexTableView.h
//  JDDemo
//
//  Created by 公司 on 2019/1/18.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDFloatIndexTableView;

@protocol JDTableViewIndexViewDataSource <NSObject>

- (NSArray *)sectionIndexTitlesForIndexTableView:(JDFloatIndexTableView *)tableView;

- (NSInteger)numberOfImageSectionsInIndexTableView:(JDFloatIndexTableView *)tableView;

@end

@interface JDFloatIndexTableView : UITableView

@property (nonatomic, weak) id<JDTableViewIndexViewDataSource> indexDataSource;

@end

NS_ASSUME_NONNULL_END
