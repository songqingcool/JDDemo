//
//  JDSenderTextView.m
//  JDMail
//
//  Created by 公司 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSenderTextView.h"
#import <YYText/YYText.h>
#import "UIColor+Extend.h"

@interface JDSenderTextView ()<YYTextViewDelegate>

@property(nonatomic, strong) YYTextView *textView;
@property(nonatomic, strong) NSMutableArray *addressList;

@end

@implementation JDSenderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.textView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
}

- (void)loadEmailAdress:(NSArray *)recipients
{
    if(recipients.count > 0) {
        [self.addressList addObjectsFromArray:recipients];
        self.textView.attributedText = [JDSenderTextView addressAttributedStringWithAddressList:self.addressList];
    }
}

#pragma mark - getter

- (YYTextView *)textView
{
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.delegate = self;
    }
    return _textView;
}

- (NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}

#pragma mark - YYTextViewDelegate

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.contentHeightBlock) {
        self.contentHeightBlock(textView.textLayout.textBoundingSize.height);
    }
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView
{
    NSString *currentString = @"";
    if (self.addressList.count) {
        for (NSString *string in self.addressList) {
            currentString = [currentString stringByAppendingString:@"  "];
            currentString = [currentString stringByAppendingString:string];
            currentString = [currentString stringByAppendingString:@"  "];
        }
    }
    
    NSArray *addressList = nil;
    if (textView.text.length == 0) {
        [self.addressList removeAllObjects];
    }else if ([currentString containsString:textView.text]) {
        NSArray *addressArray = [textView.text componentsSeparatedByString:@"  "];
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSString *addr in addressArray) {
            if (addr.length) {
                [resultArray addObject:addr];
            }
        }
        [self.addressList removeAllObjects];
        [self.addressList addObjectsFromArray:resultArray];
    }else{
        NSString *addString = [textView.text stringByReplacingOccurrencesOfString:currentString withString:@""];
        if(addString.length > 0) {
            addressList = [addString componentsSeparatedByString:@";"];
        }
    }
    [self.addressList addObjectsFromArray:addressList];
    
    self.textView.attributedText = [JDSenderTextView addressAttributedStringWithAddressList:self.addressList];
    
    if (self.endEditingBlock) {
        self.endEditingBlock(self.addressList);
    }
}

+ (NSAttributedString *)addressAttributedStringWithAddressList:(NSArray *)addressList
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i<addressList.count; i++) {
        NSString *address = [addressList objectAtIndex:i];
        NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] init];
        // 前置空格
        NSMutableAttributedString *gapString = [[NSMutableAttributedString alloc] initWithString:@"  "];
        [tempString appendAttributedString:gapString];
        // 邮件地址
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
        [attributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [attributes setValue:(id)[UIColor whiteColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
        YYTextBorder *border = [YYTextBorder new];
        border.fillColor = [UIColor greenColor];
        border.cornerRadius = 3.0;
        border.insets = UIEdgeInsetsMake(0.0, -1.0, 0.0, -1.0);
        [attributes setValue:border forKey:YYTextBackgroundBorderAttributeName];
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor whiteColor]];
        [highlight setBackgroundBorder:border];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            NSLog(@"tap text range:...");
            // 你也可以把事件回调放到 YYLabel 和 YYTextView 来处理。
        };
        [attributes setValue:highlight forKey:YYTextHighlightAttributeName];
        NSMutableAttributedString *addressString = [[NSMutableAttributedString alloc] initWithString:address attributes:attributes];
        [tempString appendAttributedString:addressString];
        // 后置空格
        NSMutableAttributedString *gapString1 = [[NSMutableAttributedString alloc] initWithString:@"  "];
        [tempString appendAttributedString:gapString1];
        // 绑定为一个字符
        [tempString yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tempString.yy_rangeOfAll];
        
        [attributedString appendAttributedString:tempString];
    }
    return attributedString;
}

+ (CGFloat)heightWithEmailAdress:(NSArray *)addressList
{
    NSAttributedString *string = [JDSenderTextView addressAttributedStringWithAddressList:addressList];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200.0, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil];
    return ceil(CGRectGetHeight(rect));
}

@end
