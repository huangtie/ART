//
//  ARTAuthorDetailViewController.m
//  ART
//
//  Created by huangtie on 16/6/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAuthorDetailViewController.h"
#import "ARTHtmlView.h"
#import "ARTRequestUtil.h"
#import "ARTBookDetailViewController.h"

typedef NS_ENUM(NSInteger, ARTAUTHOR_SECTIONS)
{
    ARTAUTHOR_SECTIONS_HEAD,
    ARTAUTHOR_SECTIONS_BOOKS,
    ARTAUTHOR_SECTIONS_CONTEXT,
    ARTAUTHOR_SECTIONS_MAX
};

@interface ARTAuthorDetailViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , copy) NSString *authorID;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UITableViewCell *headCell;
@property (nonatomic , strong) UITableViewCell *bookCell;
@property (nonatomic , strong) UITableViewCell *contentCell;

@property (nonatomic , strong) ARTAuthorData *authorData;

@property (nonatomic , strong) NSArray <ARTBookData *> * bookList;

@property (nonatomic , strong) UIImageView *face;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *sexLabel;
@property (nonatomic , strong) UILabel *remarkLabel;

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) ARTHtmlView *htmlView;

@end

@implementation ARTAuthorDetailViewController

- (instancetype)initWithAuthorID:(NSString *)authorID
{
    self = [super init];
    if (self)
    {
        self.authorID = authorID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"藏家介绍";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestAuthorData];
    }];
    
    [self displayHUD];
    [self requestAuthorData];
    [self requestBookList];
}

#pragma mark LAYOUT
#define SECTION_HEIGHT 50
#define PADING 20
- (UIView *)sectionView:(UIColor *)bgColor title:(NSString *)title
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, SECTION_HEIGHT)];
    sectionView.backgroundColor = bgColor;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(PADING, 0, 30, 4)];
    line.bottom = sectionView.height - 5;
    line.backgroundColor = COLOR_YSYC_ORANGE;
    [sectionView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(line.left, line.top - 25, 200, 20)];
    label.font = FONT_WITH_20;
    label.textColor = UICOLOR_ARGB(0xff333333);
    label.text = title;
    [sectionView addSubview:label];
    
    return sectionView;
}

- (void)bindingWithDetailData
{
    //头像
    [self.face setImageWithURL:[NSURL URLWithString:self.authorData.authorImag] placeholder:IMAGE_PLACEHOLDER_BOOK];
    
    //姓名
    self.nameLabel.text = self.authorData.authorName;
    
    //性别
    NSMutableAttributedString * sexTitle = [[NSMutableAttributedString alloc]initWithString:@"性别："];
    [sexTitle addAttribute:NSFontAttributeName value:FONT_WITH_16 range:NSMakeRange(0, sexTitle.length)];
    [sexTitle addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, sexTitle.length)];
    
    NSString *sex = @"";
    if (self.authorData.authorSex.integerValue == 0)
    {
        sex = @"男";
    }
    else if (self.authorData.authorSex.integerValue == 1)
    {
        sex = @"女";
    }
    else
    {
        sex = @"未知";
    }
    
    NSMutableAttributedString * sexText = [[NSMutableAttributedString alloc]initWithString:sex];
    [sexText addAttribute:NSFontAttributeName value:FONT_WITH_16 range:NSMakeRange(0, sexText.length)];
    [sexText addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, sexText.length)];
    
    [sexTitle appendAttributedString:sexText];
    self.sexLabel.attributedText = sexTitle;
    
    //简介
    NSMutableAttributedString * remarkTitle = [[NSMutableAttributedString alloc]initWithString:@"简介："];
    [remarkTitle addAttribute:NSFontAttributeName value:FONT_WITH_16 range:NSMakeRange(0, remarkTitle.length)];
    [remarkTitle addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, remarkTitle.length)];
    NSString *text = @"";
    if (self.authorData.authorContent.length)
    {
        text = self.authorData.authorContent;
    }
    NSMutableAttributedString * remarkText = [[NSMutableAttributedString alloc]initWithString:text];
    [remarkText addAttribute:NSFontAttributeName value:FONT_WITH_16 range:NSMakeRange(0, remarkText.length)];
    [remarkText addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, remarkText.length)];
    [remarkTitle appendAttributedString:remarkText];
    
    self.remarkLabel.attributedText = remarkTitle;
    
    CGFloat height = [remarkText.string heightForFont:FONT_WITH_16 width:self.remarkLabel.width];
    self.remarkLabel.height = height;
    if (height > 3 * 20)
    {
        self.headCell.height = self.remarkLabel.bottom + 40;
    }
    else
    {
        self.headCell.height = self.face.bottom + 40;
    }
    
    //图文简介
    if (self.authorData.authorRema.length)
    {
        self.htmlView.content = self.authorData.authorRema;
        WS(weak)
        self.htmlView.loadFinishBlock = ^(CGFloat contrlHeight)
        {
            weak.htmlView.height = contrlHeight;
            weak.contentCell.height = weak.htmlView.bottom + 10;
            [weak.tableView reloadData];
        };
        [self.contentCell.contentView addSubview:self.htmlView];
    }
    else
    {
        [self.htmlView removeFromSuperview];
        UIImageView *icon = [[UIImageView alloc] initWithImage:IMAGE_EMPTY_TWO];
        [icon sizeToFit];
        icon.center = CGPointMake(self.contentCell.width / 2, self.contentCell.height / 2);
        [self.contentCell.contentView addSubview:icon];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = FONT_WITH_15;
        textLabel.textColor = UICOLOR_ARGB(0xff666666);
        textLabel.text = @"暂无介绍";
        [textLabel sizeToFit];
        textLabel.left = (self.contentCell.width - textLabel.width) / 2;
        textLabel.top = icon.bottom + 5;
        [self.contentCell.contentView addSubview:textLabel];
    }
    
    
    [self.tableView reloadData];
}


- (void)bindingWithBookList
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.bookList.count)
    {
        CGSize size = CGSizeMake(150, 200);
        CGFloat pading = (self.scrollView.width - 4 * size.width) / 3;
        self.scrollView.contentSize = CGSizeMake(self.bookList.count * (size.width + pading), size.height);
        for (NSInteger i = 0 ; i < self.bookList.count ; i++)
        {
            ARTBookData *data = self.bookList[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.left = i * (size.width + pading);
            imageView.size = size;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setImageWithURL:[NSURL URLWithString:data.bookImage] placeholder:IMAGE_PLACEHOLDER_BOOK];
            [self.scrollView addSubview:imageView];
            
            WS(weak)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                UITapGestureRecognizer *tapGest = sender;
                NSInteger index = [weak.scrollView.subviews indexOfObject:tapGest.view];
                ARTBookData *book = weak.bookList[index];
                [ARTBookDetailViewController launchFromController:weak bookID:book.bookID];
            }];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
        }
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
        UIImageView *icon = [[UIImageView alloc] initWithImage:IMAGE_EMPTY_ONE];
        [icon sizeToFit];
        icon.center = CGPointMake(self.scrollView.width / 2, self.scrollView.height / 2);
        [self.scrollView addSubview:icon];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = FONT_WITH_15;
        textLabel.textColor = UICOLOR_ARGB(0xff666666);
        textLabel.text = @"暂无相关图集";
        [textLabel sizeToFit];
        textLabel.left = (self.scrollView.width - textLabel.width) / 2;
        textLabel.top = icon.bottom + 5;
        
        [self.scrollView addSubview:textLabel];
    }
}

#pragma mark GET_SET
- (UITableViewCell *)headCell
{
    if (!_headCell)
    {
        _headCell = [[UITableViewCell alloc] init];
        _headCell.width = self.tableView.width;
        _headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.face = [[UIImageView alloc] initWithFrame:CGRectMake(PADING, 30, 150, 150)];
        self.face.clipsToBounds = YES;
        self.face.contentMode = UIViewContentModeScaleAspectFill;
        [self.face circleBorderWidth:3 borderColor:UICOLOR_ARGB(0xfffafafa)];
        [_headCell.contentView addSubview:self.face];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.face.right + 25, self.face.top + 10, _headCell.width - self.face.right - 25 - PADING, 20)];
        self.nameLabel.font = FONT_WITH_19;
        self.nameLabel.textColor = UICOLOR_ARGB(0xff333333);
        [_headCell.contentView addSubview:self.nameLabel];
        
        self.sexLabel = [[UILabel alloc] initWithFrame:self.nameLabel.frame];
        self.sexLabel.top = self.nameLabel.bottom + 10;
        [_headCell.contentView addSubview:self.sexLabel];
        
        self.remarkLabel = [[UILabel alloc] initWithFrame:self.sexLabel.frame];
        self.remarkLabel.top = self.sexLabel.bottom + 10;
        self.remarkLabel.numberOfLines = 0;
        [_headCell.contentView addSubview:self.remarkLabel];
        
        _headCell.height = self.face.bottom + 40;
    }
    return _headCell;
}

- (UITableViewCell *)bookCell
{
    if (!_bookCell)
    {
        _bookCell = [[UITableViewCell alloc] init];
        _bookCell.width = SCREEN_WIDTH;
        _bookCell.backgroundColor = UICOLOR_ARGB(0xfffafafa);
        _bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(PADING, PADING, _bookCell.width - 2 * PADING, 200)];
        self.scrollView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [_bookCell.contentView addSubview:self.scrollView];
        
        _bookCell.height = self.scrollView.bottom + PADING;
        
    }
    return _bookCell;
}

- (UITableViewCell *)contentCell
{
    if (!_contentCell)
    {
        _contentCell = [[UITableViewCell alloc] init];
        _contentCell.width = self.tableView.width;
        _contentCell.height = 200;
        _contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _contentCell;
}

- (ARTHtmlView *)htmlView
{
    if (!_htmlView)
    {
        _htmlView = [[ARTHtmlView alloc] initWithFrame:CGRectMake(10, 10, self.contentCell.width - 20, self.contentCell.height - 20)];
    }
    return _htmlView;
}

#pragma mark REQUEST
- (void)requestAuthorData
{
    WS(weak)
    [ARTRequestUtil requestAuthorDetail:self.authorID completion:^(NSURLSessionDataTask *task, ARTAuthorData *data) {
        [weak hideHUD];
        [weak.tableView.mj_header endRefreshing];
        weak.authorData = data;
        [weak bindingWithDetailData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
        [weak.tableView.mj_header endRefreshing];
    }];
}

- (void)requestBookList
{
    ARTBookListParam *param = [[ARTBookListParam alloc] init];
    param.bookAuthor = self.authorID;
    param.limit = @"20";
    
    WS(weak)
    [ARTRequestUtil requestBookList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas) {
        weak.bookList = datas;
        [weak bindingWithBookList];
    } failure:^(ErrorItemd *error) {
        
    }];
}

#pragma mark DELEGAT_TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ARTAUTHOR_SECTIONS_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ARTAUTHOR_SECTIONS_HEAD:
        {
            return self.headCell;
        }
            break;
        case ARTAUTHOR_SECTIONS_BOOKS:
        {
            return self.bookCell;
        }
            break;
        case ARTAUTHOR_SECTIONS_CONTEXT:
        {
            return self.contentCell;
        }
            break;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ARTAUTHOR_SECTIONS_HEAD:
        {
            return self.headCell.height;
        }
            break;
        case ARTAUTHOR_SECTIONS_BOOKS:
        {
            return self.bookCell.height;
        }
            break;
        case ARTAUTHOR_SECTIONS_CONTEXT:
        {
            return self.contentCell.height;
        }
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case ARTAUTHOR_SECTIONS_HEAD:
        {
            return [self sectionView:[UIColor whiteColor] title:@"简介"];
        }
            break;
        case ARTAUTHOR_SECTIONS_BOOKS:
        {
            return [self sectionView:UICOLOR_ARGB(0xfffafafa) title:@"相关作品"];
        }
            break;
        case ARTAUTHOR_SECTIONS_CONTEXT:
        {
            return [self sectionView:[UIColor whiteColor] title:@"图文简介"];
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

@end
