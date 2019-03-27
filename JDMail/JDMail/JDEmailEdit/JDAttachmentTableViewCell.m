
//
//  JDAttachmentTableViewCell.m
//  JDMail
//
//  Created by 千阳 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAttachmentTableViewCell.h"
#import "AttachmentCollectionViewCell.h"
#import "JDAttachmentTableViewCell.h"
#import "../JDMail/JDMailAttachment.h"
#import "JDMailMessageBuilder.h"
#import "JDNetworkManager.h"
#import "GDataXMLNode.h"
#import "UIView+Frame.h"
#import "../../JDMail/JDFoundation/Network/JDAttachmentManager.h"

@interface JDAttachmentTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray *mailAttachmentArray;
@property(nonatomic,strong)UICollectionView *attachmentCollectionView;


@end

@implementation JDAttachmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.attachmentCollectionView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.attachmentCollectionView.frame = self.bounds;
}


 - (UICollectionView *)attachmentCollectionView
{
    if(!_attachmentCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _attachmentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _attachmentCollectionView.backgroundColor = [UIColor clearColor];
        _attachmentCollectionView.dataSource = self;
        _attachmentCollectionView.delegate = self;
        _attachmentCollectionView.showsHorizontalScrollIndicator = NO;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        [_attachmentCollectionView registerClass:[AttachmentCollectionViewCell class] forCellWithReuseIdentifier:@"AttachmentCollectionViewCellIdentifier"];
        
    }
    return _attachmentCollectionView;
}

- (NSArray *)mailAttachmentArray
{
    if(!_mailAttachmentArray)
    {
        _mailAttachmentArray = [NSArray new];
    }
    return _mailAttachmentArray;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mailAttachmentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.height+20,collectionView.height);
}

 - (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttachmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    JDMailAttachment *mailAttachment = self.mailAttachmentArray[indexPath.row];
    
    [cell reloadDataWithModel:mailAttachment];
    return cell;
}

- (void)reloadDataWithMailAttachmentArray:(NSArray *)mailAttachmentArray
{
    self.mailAttachmentArray = [NSArray arrayWithArray:mailAttachmentArray];
    
    [[JDAttachmentManager shareManager] getAttachments:self.mailAttachmentArray success:^(NSArray * _Nonnull attachments) {
        
        NSArray *array = [self attachmentsFilterInline:attachments];
        
        self.mailAttachmentArray = array;
        
        [self.attachmentCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    NSMutableArray *attachmentArray = [NSMutableArray new];
    if(self.mailAttachmentArray.count)
    {
        for (JDMailAttachment *attachment in self.mailAttachmentArray) {
            
            [attachmentArray addObject:attachment.attachmentId];
            
        }
    }
}

-(NSArray *)attachmentsFilterInline:(NSArray *)attachments
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:attachments];
    for (JDMailAttachment *attachment in attachments) {
        
        if([attachment.contentType containsString:@"image"] && attachment.isInline)
        {
            [array removeObject:attachment];
        }
    }
    return array;
}
@end
