//
//  EmailContentCell.m
//  JDMail
//
//  Created by 千阳 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import "EmailContentCell.h"
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"
#import "JDAttachmentManager.h"
#import "JDMailAttachment.h"

@interface EmailContentCell()<WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation EmailContentCell
{
    @private
    NSString *bodyContent;
    NSArray *attachmentArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.webView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.webView.frame = self.contentView.frame;
    NSLog(@"self.contentView.height :%f",self.webView.height);
}


- (WKWebView *)webView
{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] init];
        _webView.frame = self.contentView.bounds;
        _webView.navigationDelegate = self;
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"richText_editor"                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [_webView loadHTMLString:htmlCont baseURL:nil];
        _webView.scrollView.bounces=NO;
        
    }
    return _webView;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=5.0, minimum-scale=1.0, user-scalable=yes\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    if(bodyContent)
    {
        bodyContent = [bodyContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        bodyContent = [bodyContent stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
        NSString *js = [NSString stringWithFormat:@"document.getElementById('article_footer').innerHTML='%@';document.getElementById(\"article_content\").style.visibility=\"hidden\";document.body.scrollLeft=0;var imgs = document.getElementsByTagName(\"img\");for(var i =0; i<imgs.length;i++){if(imgs[i].width>window.screen.width){imgs[i].style.width = \"100%%\";imgs[i].style.height = \"auto\";}}var divs = document.getElementById(\"article_footer\").getElementsByTagName(\"div\");for(var i =0; i<divs.length;i++){divs[i].style.width = \"100%%\";divs[i].style.height = \"auto\";}var tables = document.getElementsByTagName(\"table\");for(var i =0; i<tables.length;i++){tables[i].style.width = \"100%%\";tables[i].style.height = \"auto\";}",bodyContent];
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            
            [self loadAttachment:self->attachmentArray];
            
        }];
        
        //document.documentElement.offsetHeight
        //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
        
        // width:100%;
        // height:auto;
        
        [webView evaluateJavaScript:@"document.getElementById(\"wrap\").offsetHeight;" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
            
            CGFloat webViewHeight = [result doubleValue];
            self.emialHtmlBodyHeight(webViewHeight);
            self.contentView.height = webViewHeight;
            self.webView.height = webViewHeight;
            self.webView.width = self.contentView.width;
        }];
        
        
        
        NSString *doc = @"document.documentElement.outerHTML";
        [self.webView evaluateJavaScript:doc
                       completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                           if (error) {
                               NSLog(@"JSError:%@",error);
                           }
                           NSLog(@"html:%@",htmlStr);
                       }] ;
        
    }
}


- (void)reloadWithParams:(NSDictionary *)params
{
    
//    [self.webView reload];
    bodyContent = params[@"bodyHtml"];
    attachmentArray = params[@"attachments"];
    
//    NSString *doc = @"document.body.outerHTML";
//    [self.webView evaluateJavaScript:doc completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
//
//        NSString *html = htmlStr;
//        NSLog(@"%@",htmlStr);
//
//    }];
 
    if(attachmentArray && attachmentArray.count >0)
    {
    
        NSMutableArray *imagesAttachmentArray = [NSMutableArray arrayWithArray:attachmentArray];
        
        for (JDMailAttachment *attachment in attachmentArray) {
         
            if(![attachment.contentType containsString:@"image"])
            {
                [imagesAttachmentArray removeObject:attachment];
            }
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (float)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
            
//        });
        
    }
}

- (void)loadAttachment:(NSArray *)imagesAttachmentArray
{
    if(imagesAttachmentArray && imagesAttachmentArray.count >0)
    {
        [[JDAttachmentManager shareManager] getAttachments:imagesAttachmentArray success:^(NSArray * _Nonnull attachments) {
            
            for (JDMailAttachment *attachment in attachments) {
                
                NSString *js = [NSString stringWithFormat:@"var imgs = document.getElementsByTagName(\"img\");for(var i =0; i<imgs.length;i++){if(imgs[i].src == \"cid:%@\"){imgs[i].src=\"data:image/png;base64,%@\";}}",attachment.contentId,attachment.content];
                
                
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                    
                    if (error) {
                        NSLog(@"JSError:%@",error);
                    }
                    else
                    {
                        NSLog(@"html:%@",htmlStr);
                    }
                    
                }];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            NSLog(@"replace Attachment Image src error:%@",error.description);
            
        }];
    }
}

@end
