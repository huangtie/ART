//
//  ARTHtmlView.m
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTHtmlView.h"

@interface ARTHtmlView()<UIWebViewDelegate,UIScrollViewDelegate>



@end

@implementation ARTHtmlView

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        [self contrlSeting];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self contrlSeting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self contrlSeting];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self contrlSeting];
}

- (void)contrlSeting
{
    //背景色
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.opaque = NO;
    
    self.scrollView.delegate = self;
    
}

#pragma mark 重写
- (void)setContent:(NSString *)content
{
    _content = content;
    
    [self loadHTMLString:[self apendContent:content] baseURL:nil];
    
}

#pragma mark 数据拼接
- (NSString *)apendContent:(NSString *)content
{
    NSData *htmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser=[[TFHpple alloc]initWithHTMLData:htmlData];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:@"//img"];
    
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in elements)
    {
        NSDictionary *elementContent =[[NSDictionary alloc] initWithDictionary:[element attributes]];
        [strings addObject:elementContent];
    }
    
    NSMutableString *newString = [content mutableCopy];
    NSInteger offet = 0;
    
    for (NSDictionary *elementContent in strings)
    {
        NSString *imageStr = [elementContent objectForKey:@"src"];
        
        if(imageStr.length > 4)
        {
            if(![[imageStr substringToIndex:4] isEqualToString:@"http"])
            {
                NSRange range = [newString rangeOfString:imageStr options:NSCaseInsensitiveSearch range:NSMakeRange(offet , newString.length - offet)];
                
                offet = (range.location + range.length + HOST.length);
                
                if (range.location != NSNotFound && range.location < newString.length)
                {
                    [newString insertString:HOST atIndex:range.location];
                }
            }
        }
        
    }
    
    return newString;
}

#pragma mark 代理
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.height = webView.scrollView.contentSize.height;
    
    if(self.loadFinishBlock)
    {
        self.loadFinishBlock(webView.scrollView.contentSize.height);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.height = webView.scrollView.contentSize.height;
    
    if(self.loadFinishBlock)
    {
        self.loadFinishBlock(webView.scrollView.contentSize.height);
    }
}

#pragma mark 背部代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = scrollView.contentOffset;
    
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight   = scrollView.frame.size.height;
    
    if(point.y < 0)
        
    {
        
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
        
    }
    else if(contentHeight > frameHeight)
    {
        
        if(contentHeight - point.y < frameHeight)
            
        {
            
            [scrollView setContentOffset:CGPointMake(point.x, contentHeight - frameHeight) animated:NO];
            
        }
        
    }
    else if(contentHeight <= frameHeight)
    {
        
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
        
    }
    
}

@end
