//
//  AttachmentCollectionViewCell.m
//  JDMail
//
//  Created by 千阳 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import "AttachmentCollectionViewCell.h"
#import "../../../JDMail/JDMail/JDMail/JDMailAttachment.h"
#import "UIView+Frame.h"

@interface AttachmentCollectionViewCell()

@property(nonatomic,strong)UIImageView *fileImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *sizeLabel;

@end

@implementation AttachmentCollectionViewCell
{
    @private
    CGFloat labelHeight;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        labelHeight = 20;
        [self.contentView addSubview:self.fileImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sizeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.fileImageView.frame=self.contentView.bounds;
    self.nameLabel.frame=CGRectMake(0, self.contentView.height-labelHeight-labelHeight, self.contentView.width, labelHeight);
    self.sizeLabel.frame=CGRectMake(0, self.contentView.height-labelHeight, self.contentView.width, labelHeight);
    
}

-(UIImageView *)fileImageView
{
    if(!_fileImageView)
    {
        _fileImageView = [[UIImageView alloc] init];
    }
    return _fileImageView;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:.8];
        _nameLabel.textColor = [UIColor grayColor];
    }
    return _nameLabel;
}

- (UILabel *)sizeLabel
{
    if(!_sizeLabel)
    {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
        _sizeLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:.8];
        _sizeLabel.textColor = [UIColor grayColor];
    }
    return _sizeLabel;
}


- (void)reloadDataWithModel:(JDMailAttachment *)mailAttachment
{
    if(mailAttachment.content)
    {
        NSData *imageData = [self convertBase64ToData:mailAttachment.content];
        UIImage *image = [UIImage imageWithData:imageData];
        self.fileImageView.image = image;
    }
    self.nameLabel.text = mailAttachment.name;
    
    self.sizeLabel.text = mailAttachment.sizeStr;
}

- (NSData *)convertBase64ToData:(NSString *)base64String
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return decodedData;
}


@end
