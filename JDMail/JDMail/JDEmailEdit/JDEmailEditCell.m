
//
//  EmailEditCell.m
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDEmailEditCell.h"

#import "WGCommon.h"
#import "HXPhotoPicker.h"
#import "HXAlbumListViewController.h"
#import "UIView+Frame.h"
#import <WebKit/WebKit.h>
#import "GTMNSString+HTML.h"
#import <JavaScriptCore/JSContext.h>
#import "../../JDMail/JDFoundation/Network/JDAttachmentManager.h"
#import "../../JDMail/JDMail/JDMailAttachment.h"


#define kEditorURL @"richText_editor"

@interface  JDEmailEditCell()<UITextViewDelegate,UIWebViewDelegate,KWEditorBarDelegate,KWFontStyleBarDelegate,HXAlbumListViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

//
@property (nonatomic,strong) KWEditorBar *toolBarView;
@property (nonatomic,strong) KWFontStyleBar *fontBar;
@property (nonatomic,strong) HXPhotoManager *manager;
@property (nonatomic,strong) HXPhotoView *photoView;

/**
 *  存放所有正在上传及失败的图片model
 */
@property (nonatomic,strong) NSMutableArray *uploadPics;

@end

@implementation JDEmailEditCell
{
    @private
    CGFloat SCREEN_WIDTH,SCREEN_HEIGHT;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.webView];
//        [self.contentView addSubview:self.toolBarView];
        [[UIApplication sharedApplication].delegate.window addSubview:self.toolBarView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        self.toolBarView.delegate = self;
        [self.toolBarView addObserver:self forKeyPath:@"transform" options:
         NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    SCREEN_WIDTH = self.contentView.frame.size.width;
    SCREEN_HEIGHT = self.contentView.frame.size.height;
    self.webView.frame = self.contentView.bounds;
 
    if(self.toolBarView.top == 0)
    {
        self.toolBarView.frame = CGRectMake(0,ScreenHeight-KWEditorBar_Height, ScreenWidth, KWEditorBar_Height);
    }
}

- (NSMutableArray *)uploadPics{
    if (!_uploadPics) {
        _uploadPics = [NSMutableArray array];
    }
    return _uploadPics;
}

- (KWEditorBar *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [KWEditorBar editorBar];
        _toolBarView.backgroundColor = COLOR(237, 237, 237, 1);
    }
    return _toolBarView;
}

- (KWFontStyleBar *)fontBar{
    if (!_fontBar) {
        _fontBar = [[KWFontStyleBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame) - KWFontBar_Height - KWEditorBar_Height, ScreenWidth, KWFontBar_Height)];
        _fontBar.delegate = self;
        [_fontBar.heading2Item setSelected:YES];

    }
    return _fontBar;
}

- (NSString *)emailContentHtml
{
    return [self.webView contentHtmlText];
}

- (void)getHTMLText{
    
    NSLog(@"%@",[self.webView contentHtmlText]);
}

- (void)addOriginalEmial:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
     NSString *js = [NSString stringWithFormat:@"RE.addFooter('%@')",html];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.webView stringByEvaluatingJavaScriptFromString:js];
        
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"transform"]){
        CGRect fontBarFrame = self.fontBar.frame;
        fontBarFrame.origin.y = CGRectGetMaxY(self.toolBarView.frame)- KWFontBar_Height - KWEditorBar_Height;
        self.fontBar.frame = fontBarFrame;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:kEditorURL                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
        _webView.scrollView.bounces=NO;
        
        _webView.hidesInputAccessoryView = YES;
        //_webView.detectsPhoneNumbers = NO;
        
    }
    return _webView;
}


#pragma mark -webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    if(self.originalEmailHtml)
        [self addOriginalEmial:self.originalEmailHtml];
    
    context[@"bodySizeChanged"] = ^(){

        NSArray *args = [JSContext currentArguments];
        JSValue *arg1 = [args firstObject];
       NSString *arg1Str = [NSString stringWithFormat:@"%@",arg1];
        long long height = [arg1Str longLongValue];
//        height = 800;
        if(height>300)
        {
            self.webView.height = height;
            self.contentDivHeight(height);
            self.contentView.height = height;
        }
    };
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"NSError = %@",error);
    
    if([error code] == NSURLErrorCancelled){
        return;
    }
}
//获取IMG标签
-(NSArray*)getImgTags:(NSString *)htmlText
{
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"loadURL = %@",urlString);
    
    [self handleEvent:urlString];

    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"re-state-content://" withString:@""];
        
        [self.fontBar updateFontBarWithButtonName:className];
        
        if ([self.webView contentText].length <= 0) {
            [self.webView showContentPlaceholder];
            if ([self getImgTags:[self.webView contentHtmlText]].count > 0) {
                [self.webView clearContentPlaceholder];
            }
        }else{
            [self.webView clearContentPlaceholder];
        }
        
        if ([[className componentsSeparatedByString:@","] containsObject:@"unorderedList"]) {
            [self.webView clearContentPlaceholder];
        }
    }
    [self handleWithString:urlString];
    return YES;
}
#pragma mar - webView监听处理事件
- (void)handleEvent:(NSString *)urlString{
    if ([urlString hasPrefix:@"re-state-content://"]) {
        self.fontBar.hidden = NO;
        self.toolBarView.hidden = NO;
        
       NSInteger bodyHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
        
        self.contentView.height = bodyHeight;
        
//        if ([self.webView contentText].length <= 0) {
//            [self.webView.scrollView setContentOffset:CGPointMake(0, self.contentView.height) animated:YES];
//        }
    }
    
    if ([urlString hasPrefix:@"re-state-title://"]) {
        self.fontBar.hidden = YES;
        self.toolBarView.hidden = YES;
    }
}

#pragma mark -editorbarDelegate
- (void)editorBar:(KWEditorBar *)editorBar didClickIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //显示或隐藏键盘
            if (self.toolBarView.transform.ty < 0) {
                [self.webView hiddenKeyboard];
            }else{
                [self.webView showKeyboardContent];
            }
        }
            break;
        case 1:{
            //回退
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('undo')"];
        }
            break;
        case 2:{
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('redo')"];
        }
            break;
        case 3:{
            //显示更多区域
            editorBar.fontButton.selected = !editorBar.fontButton.selected;
            if (editorBar.fontButton.selected) {
                [[UIApplication sharedApplication].delegate.window addSubview:self.fontBar];
            }else{
                [self.fontBar removeFromSuperview];
            }
        }
            break;
        case 4:{
            //插入地址
            [self.webView insertLinkUrl:@"https://www.baidu.com/" title:@"百度" content:@"百度一下"];
        }break;
        case 5:{
            //插入图片
            if (!self.toolBarView.keyboardButton.selected) {
                [self.webView showKeyboardContent];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPhotos];
                });
            }else{
                [self showPhotos];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - fontbardelegate
- (void)fontBar:(KWFontStyleBar *)fontBar didClickBtn:(UIButton *)button{
    if (self.toolBarView.transform.ty>=0) {
        [self.webView showKeyboardContent];
    }
    switch (button.tag) {
        case 0:{
            //粗体
            [self.webView bold];
        }
            break;
        case 1:{//下划线
            [self.webView underline];
        }
            break;
        case 2:{//斜体
            [self.webView italic];
        }
            break;
        case 3:{//14号字体
            [self.webView setFontSize:@"2"];
        }
            break;
        case 4:{//16号字体
            [self.webView setFontSize:@"3"];
        }
            break;
        case 5:{//18号字体
            [self.webView setFontSize:@"4"];
        }
            break;
        case 6:{//左对齐
            [self.webView justifyLeft];
        }
            break;
        case 7:{//居中对齐
            [self.webView justifyCenter];
        }
            break;
        case 8:{//右对齐
            [self.webView justifyRight];
        }
            break;
        case 9:{//无序
            [self.webView unorderlist];
        }
            break;
        case 10:{
            //缩进
            button.selected = !button.selected;
            if (button.selected) {
                [self.webView indent];
            }else{
                [self.webView outdent];
            }
        }
            break;
        case 11:{
            
        }
            break;
        default:
            break;
    }
}

- (void)fontBarResetNormalFontSize{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView normalFontSize];
    });
}

#pragma mark -keyboard
- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform =  CGAffineTransformIdentity;
            self.toolBarView.keyboardButton.selected = NO;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
             self.toolBarView.transform = CGAffineTransformMakeTranslation(0, 0-frame.size.height);
            self.toolBarView.keyboardButton.selected = YES;
            
        }];
    }
}

#pragma mark -上传图片
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    
    [self.manager clearSelectedList];
    
    if (photoList.count > 0) {
        for (int i = 0; i<photoList.count; i++) {
            
            HXPhotoModel *picM = photoList[i];
            WGUploadPictureModel *uploadM = [[WGUploadPictureModel alloc] init];
            uploadM.image = picM.thumbPhoto;
            uploadM.key = [NSString uuid];
            uploadM.imageData = UIImageJPEGRepresentation(picM.thumbPhoto,0.8f);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //1、插入本地图片
                [self.webView inserImage:uploadM.imageData key:uploadM.key];
                
                //2、模拟网络请求上传图片 更新进度
                [self.webView inserImageKey:uploadM.key progress:0.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.webView inserImageKey:uploadM.key progress:1];
                    //                    BOOL error = false; //上传成功样式
                    BOOL error = NO; //上传失败样式
                    if (!error) {
                        //3、上传成功替换返回的网络地址图片
                        [self.webView inserSuccessImageKey:uploadM.key imgUrl:@"http://b-ssl.duitang.com/uploads/item/201505/30/20150530214639_VJxTQ.jpeg"];
                        
                        uploadM.type = WGUploadImageModelTypeError;
                        
                        if ([self.uploadPics containsObject:uploadM]) {
                            [self.uploadPics removeObject:uploadM];
                        }
                    }else{
                        //3、上传失败 显示失败的样式
                        [self.webView uploadErrorKey:uploadM.key];
                        
                        uploadM.type = WGUploadImageModelTypeError;
                        
                        [self.uploadPics addObject:uploadM];
                    }
                });
            });
        }
    }
}

#pragma mark -图片点击操作
- (BOOL)handleWithString:(NSString *)urlString{
    
    //点击的图片标记URL（自定义）
    NSString *preStr = @"protocol://iOS?code=uploadResult&data=";
    
    if ([urlString hasPrefix:preStr]) {
        NSString *result = [urlString stringByReplacingOccurrencesOfString:preStr withString:@" "];
        NSString *jsonString = [result stringByRemovingPercentEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

        __unused NSString *meg = [NSString stringWithFormat:@"上传的图片ID为%@",dict[@"imgId"]];
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:meg message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //上传状态 - 默认上传成功
        BOOL uploadState = YES;
        
        for (WGUploadPictureModel *upPic in self.uploadPics) {
            if (upPic.type == WGUploadImageModelTypeError) {
                //上传失败的
                uploadState = false;
            }
        }
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:uploadState?@"删除图片":@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //根据自身业务需要处理图片操作：如删除、重新上传图片操作等
            if (uploadState) {
                //例如删除图片执行函数imgID=key;
                [self.webView deleteImageKey:dict[@"imgId"]];
            }else{
                //见387行代码 上传片段 。。。
            }
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
         */
        return NO;
    }
    return YES;
}

#pragma mark -图片选择器
- (void)showPhotos{
    
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = self.manager.configuration.supportRotation;
    self.showPhotoController(nav);
//    [self presentViewController:nav animated:YES completion:nil];
    
    
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.toolBarTitleColor = COLOR(33,189,109,1);
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.imageMaxSize = 5;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.singleJumpEdit = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.supportRotation = NO;
        _manager.configuration.hideOriginalBtn = NO;
        _manager.configuration.navigationTitleColor = [UIColor blackColor];
        _manager.configuration.showDateSectionHeader =NO;
        _manager.configuration.singleSelected = NO;
    }
    return _manager;
}


- (void)reloadAttachment:(NSArray *)attachments
{
    if(attachments && attachments.count >0)
    {
        
        NSMutableArray *imagesAttachmentArray = [NSMutableArray arrayWithArray:attachments];
        
        for (JDMailAttachment *attachment in attachments)//去掉非图片的附件
        {
            
            if(![attachment.contentType containsString:@"image"])
            {
                [imagesAttachmentArray removeObject:attachment];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (float)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [[JDAttachmentManager shareManager] getAttachments:imagesAttachmentArray success:^(NSArray * _Nonnull attachments) {
                
                for (JDMailAttachment *attachment in attachments) {
                    
                    NSString *js = [NSString stringWithFormat:@"Email.ReplaceImgSrc('%@','%@')",attachment.contentId,attachment.content];
                    [self.webView stringByEvaluatingJavaScriptFromString:js];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                NSLog(@"replace Attachment Image src error:%@",error.description);
                
            }];
            
        });
        
    }
}

- (void)dealloc
{
    @try
    {
        [self.toolBarView removeObserver:self forKeyPath:@"transform"];
    }
    @catch (NSException *exception)
    {
        NSLog(@"JDEmailEditCell_Exception: %@", exception);
    }
    @finally {
    }
}

@end
