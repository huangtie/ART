//
//  ARTBookDetailViewController.m
//  ART
//
//  Created by huangtie on 16/5/26.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookDetailViewController.h"
#import "ARTBookData.h"
#import "ARTRequestUtil.h"
#import "ARTBookComentCell.h"
#import <UIImageView+WebCache.h>
#import "ARTBookInputView.h"

typedef NS_ENUM(NSInteger, ARTDETAIL_SECTIONS)
{
    ARTDETAIL_SECTIONS_AUTHOR,
    ARTDETAIL_SECTIONS_CONTENT,
    ARTDETAIL_SECTIONS_COMMENT,
    ARTDETAIL_SECTIONS_MAX
};

@interface ARTBookDetailViewController()<
UITableViewDelegate,
UITableViewDataSource,
ARTBookInputViewDelegate>

@property (nonatomic , copy) NSString *bookID;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) ARTBookData *bookData;

@property (nonatomic , strong) NSMutableArray<ARTCommentData *> *commentDatas;

@property (nonatomic , strong) UITableViewCell *authorCell;
@property (nonatomic , strong) UIImageView *authorFace;
@property (nonatomic , strong) UILabel *authorNameLabel;
@property (nonatomic , strong) UILabel *authorRemarkLabel;


@property (nonatomic , strong) UITableViewCell *contentCell;

@property (nonatomic , strong) UITableViewCell *emptyCell;

@property (nonatomic , strong) UILabel *comcountLabel;

@property (nonatomic , strong) ARTBookInputView *inputView;

@end

@implementation ARTBookDetailViewController

+ (ARTBookDetailViewController *)launchFromController:(ARTBaseViewController *)controller
                                               bookID:(NSString *)bookID
{
    ARTBookDetailViewController *detailVC = [[ARTBookDetailViewController alloc] init];
    detailVC.bookID = bookID;
    [controller.navigationController pushViewController:detailVC animated:YES];
    return detailVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图集详情";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithMore:self action:@selector(_rightItemClicked:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH - self.inputView.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
    self.inputView.bottom = self.view.height;
    [self.view addSubview:self.inputView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestWithBookData];
    }];
    
    [self.tableView addMJRefreshFooter:^{
        [weak requestCommentList:NO];
    }];
    
    [self requestWithBookData];
}

#pragma mark METHOD
- (UILabel *)sectionTitleLabel:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    label.font = FONT_WITH_16;
    label.textColor = COLOR_YSYC_ORANGE;
    label.text = title;
    [label sizeToFit];
    label.height = 20;
    return label;
}

#pragma mark LAYOUT
- (void)updateSubviews
{
    //藏家头像
    [self.authorFace sd_setImageWithURL:[NSURL URLWithString:self.bookData.author.authorImag] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
    
    //藏家姓名
    self.authorNameLabel.text = self.bookData.author.authorName;
    
    //藏家简介
    NSString *remark = self.bookData.author.authorContent;
    self.authorRemarkLabel.text = remark;
    CGSize size = [remark sizeForFont:self.authorRemarkLabel.font size:CGSizeMake(self.authorRemarkLabel.width, 100) mode:NSLineBreakByWordWrapping];
    if (size.height > 60)
    {
        self.authorRemarkLabel.height = 60;
    }
    else
    {
        self.authorRemarkLabel.height = size.height;
    }
    
    //评论数
    self.comcountLabel.text = STRING_FORMAT(self.bookData.bookComments, @"人评");
    
    [self.tableView reloadData];
}

#pragma mark GET_SET
- (NSMutableArray *)commentDatas
{
    if (!_commentDatas)
    {
        _commentDatas = [NSMutableArray array];
    }
    return _commentDatas;
}

#define ARROW_PADDING 40
- (UITableViewCell *)authorCell
{
    if (!_authorCell)
    {
        _authorCell = [[UITableViewCell alloc] init];
        UILabel *titleLabel = [self sectionTitleLabel:@"藏家介绍:"];
        [_authorCell.contentView addSubview:titleLabel];
        self.authorFace = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 20, 100, 100)];
        self.authorFace.contentMode = UIViewContentModeScaleAspectFill;
        [self.authorFace circleBorderWidth:3 borderColor:UICOLOR_ARGB(0xffe6e6e6)];
        [_authorCell.contentView addSubview:self.authorFace];
        self.authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.authorFace.right + 40, self.authorFace.top + 5, 300, 20)];
        self.authorNameLabel.font = FONT_WITH_15;
        self.authorNameLabel.textColor = COLOR_BARTINT_GRAY;
        [_authorCell.contentView addSubview:self.authorNameLabel];
        self.authorRemarkLabel = [[UILabel alloc] init];
        self.authorRemarkLabel.font = self.authorNameLabel.font;
        self.authorRemarkLabel.textColor = self.authorNameLabel.textColor;
        self.authorRemarkLabel.left = self.authorNameLabel.left;
        self.authorRemarkLabel.top = self.authorNameLabel.bottom + 10;
        self.authorRemarkLabel.size = CGSizeMake(500, 20);
        self.authorRemarkLabel.numberOfLines = 0;
        [_authorCell.contentView addSubview:self.authorRemarkLabel];
        
        _authorCell.size = CGSizeMake(self.view.width, self.authorFace.bottom + 20);
        UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_arrowright"]];
        [arrowIcon sizeToFit];
        arrowIcon.right = _authorCell.width - ARROW_PADDING;
        arrowIcon.top = (_authorCell.height - arrowIcon.height) / 2;
        [_authorCell.contentView addSubview:arrowIcon];
    }
    return _authorCell;
}

- (UITableViewCell *)contentCell
{
    if (!_contentCell)
    {
        _contentCell = [[UITableViewCell alloc] init];
        _contentCell.contentView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
        UILabel *titleLabel = [self sectionTitleLabel:@"图文介绍:"];
        [_contentCell.contentView addSubview:titleLabel];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_pic"]];
        [icon sizeToFit];
        icon.top = titleLabel.bottom + 5;
        icon.left = titleLabel.right + 5;
        [_contentCell.contentView addSubview:icon];
        
        _contentCell.size = CGSizeMake(self.view.width, icon.bottom + 20);
        UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_arrowright"]];
        [arrowIcon sizeToFit];
        arrowIcon.right = _contentCell.width - ARROW_PADDING;
        arrowIcon.top = (_contentCell.height - arrowIcon.height) / 2;
        [_contentCell.contentView addSubview:arrowIcon];
    }
    return _contentCell;
}

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell)
    {
        _emptyCell = [[UITableViewCell alloc] init];
        _emptyCell.size = CGSizeMake(self.view.width, 600);
        _emptyCell.contentView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGE_EMPTY_TWO];
        [imageView sizeToFit];
        imageView.top = 100;
        imageView.left = (self.view.width - imageView.width) / 2;
        [_emptyCell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无评论";
        label.font = FONT_WITH_16;
        label.textColor = UICOLOR_ARGB(0xffc6c6c6);
        [label sizeToFit];
        label.top = imageView.bottom + 10;
        label.left = (self.view.width - label.width) / 2;
        [_emptyCell.contentView addSubview:label];
    }
    return _emptyCell;
}

- (UILabel *)comcountLabel
{
    if (!_comcountLabel)
    {
        _comcountLabel = [[UILabel alloc] init];
        _comcountLabel.size = CGSizeMake(300, 20);
        _comcountLabel.font = FONT_WITH_15;
        _comcountLabel.textColor = COLOR_BARTINT_GRAY;
        _comcountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _comcountLabel;
}

- (ARTBookInputView *)inputView
{
    if (!_inputView)
    {
        _inputView = [[ARTBookInputView alloc] init];
        _inputView.delegate = self;
    }
    return _inputView;
}

#pragma mark REQUEST
- (void)requestWithBookData
{
    WS(weak)
    [ARTRequestUtil requestBookDetail:self.bookID completion:^(NSURLSessionDataTask *task, ARTBookData *data) {
        weak.bookData = data;
        [weak requestCommentList:YES];
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestCommentList:(BOOL)isRefresh
{
    ARTCommentListParam *param = [[ARTCommentListParam alloc] init];
    param.bookID = self.bookID;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.commentDatas.count));
    param.limit = ARTPAGESIZE;
    
    WS(weak)
    [ARTRequestUtil requestCommentList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTCommentData *> *datas) {
        if (isRefresh)
        {
            [weak.tableView.mj_header endRefreshing];
            [weak.commentDatas removeAllObjects];
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.commentDatas addObjectsFromArray:datas];
        [weak updateSubviews];
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestSendComment:(NSString *)text scole:(NSString *)sole
{
    ARTCommentSendParam *param = [[ARTCommentSendParam alloc] init];
    param.commentText = text;
    param.commentPoint = sole;
    param.bookID = self.bookID;
    [ARTUserManager sharedInstance].userinfo.c = @"1e87f58e7f78cfa5c1987afbe29d343ce7e7929cadc4bb8ed559eec21e72b10d";
    WS(weak)
    [ARTRequestUtil requestSendComment:param completion:^(NSURLSessionDataTask *task) {
        [weak.view displayTostSuccess:@"发表成功!"];
        [weak.inputView cleanText];
        [weak requestWithBookData];
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE_TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ARTDETAIL_SECTIONS_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case ARTDETAIL_SECTIONS_AUTHOR:
        {
            return 1;
        }
            break;
        case ARTDETAIL_SECTIONS_CONTENT:
        {
            return 1;
        }
            break;
        case ARTDETAIL_SECTIONS_COMMENT:
        {
            return self.commentDatas.count ? self.commentDatas.count : 1;
        }
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ARTDETAIL_SECTIONS_AUTHOR:
        {
            return self.authorCell;
        }
            break;
        case ARTDETAIL_SECTIONS_CONTENT:
        {
            return self.contentCell;
        }
            break;
        case ARTDETAIL_SECTIONS_COMMENT:
        {
            if (self.commentDatas.count)
            {
                static NSString *identfer = @"bookcommentcell";
                ARTBookComentCell *cell = [tableView dequeueReusableCellWithIdentifier:identfer];
                if (!cell)
                {
                    cell = [[ARTBookComentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfer];
                }
                
                [cell bindingWithData:self.commentDatas[indexPath.row] isW:indexPath.row % 2];
                
                return cell;
            }
            else
            {
                return self.emptyCell;
            }
        }
        default:
        {
            return 0;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ARTDETAIL_SECTIONS_AUTHOR:
        {
            return self.authorCell.height;
        }
            break;
        case ARTDETAIL_SECTIONS_CONTENT:
        {
            return self.contentCell.height;
        }
            break;
        case ARTDETAIL_SECTIONS_COMMENT:
        {
            if (self.commentDatas.count)
            {
                ARTCommentData *data = self.commentDatas[indexPath.row];
                return [ARTBookComentCell cellHeight:data.commentText];
            }
            else
            {
                return self.emptyCell.height;
            }
        }
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case ARTDETAIL_SECTIONS_COMMENT:
        {
            UIView *section = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
            section.backgroundColor = [UIColor whiteColor];
            UILabel *titleLabel = [self sectionTitleLabel:@"评论列表"];
            [section addSubview:titleLabel];
            section.height = titleLabel.bottom + 20;
            self.comcountLabel.top = titleLabel.top;
            self.comcountLabel.right = section.width - ARROW_PADDING;
            [section addSubview:self.comcountLabel];
            return section;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case ARTDETAIL_SECTIONS_COMMENT:
        {
            return 60;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark DELEGATE_INPUTVIEW
- (void)bookInputViewDidDoSend:(NSString *)text scole:(NSString *)scole
{
    [self requestSendComment:text scole:scole];
}

@end
