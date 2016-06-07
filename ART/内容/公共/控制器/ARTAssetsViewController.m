//
//  ARTAssetsViewController.m
//  ART
//
//  Created by huangtie on 16/6/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAssetsViewController.h"
#import "ARTPreviewViewController.h"

@protocol ARTAssetItemDelegate <NSObject>
@optional

- (void)assetItemDidChooseImage:(ALAsset *)asset;

@end

@interface ARTAssetItem()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) UIButton *chosseButton;

@property (nonatomic , strong) ALAsset *asset;

@property (nonatomic , assign) id<ARTAssetItemDelegate> delegate;

@end

@implementation ARTAssetItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.chosseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chosseButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_9"] forState:UIControlStateNormal];
        [self.chosseButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_10"] forState:UIControlStateSelected];
        self.chosseButton.size = CGSizeMake(40, 40);
        self.chosseButton.userInteractionEnabled = NO;
        self.chosseButton.top = 2;
        self.chosseButton.right = self.width - 2;
        [self addSubview:self.chosseButton];
        
    }
    return self;
}

- (void)update:(ALAsset *)asset isSelect:(BOOL)isSelect
{
    self.asset = asset;
    
    CGImageRef thumbnailImageRef = [asset thumbnail];
    self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    
    self.chosseButton.selected = isSelect;
}


- (void)cheakAssetAction
{
    [self.delegate assetItemDidChooseImage:self.asset];
}

@end

@interface ARTAssetsViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ARTAssetItemDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *assetsChooses;

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UILabel *circle;

@end

@implementation ARTAssetsViewController

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择相片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_backItemClicked:)];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.assets = [NSMutableArray array];
    self.assetsChooses = [NSMutableArray array];
    
    CGSize size = CGSizeMake(self.view.width, self.view.height - NAVIGATION_HEIGH - self.toolBar.height);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.5];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setItemSize:CGSizeMake(size.width / 5 - 2, size.width / 5)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, size.width, size.height) collectionViewLayout: flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.collectionView registerClass:[ARTAssetItem class] forCellWithReuseIdentifier:@"assetcell"];
    [self.view addSubview:self.collectionView];
    
    self.toolBar.bottom = self.view.height;
    [self.view addSubview:self.toolBar];
    
    [self loadAssets];
}

#pragma mark GET_SET
- (NSInteger)multipleMax
{
    if (_multipleMax <= 0)
    {
        _multipleMax = 9;
    }
    return _multipleMax;
}

- (UIView *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _toolBar.backgroundColor = RGBCOLOR(100, 100, 100, .5);
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.previewButton setTitleColor:RGBCOLOR(150, 150, 150, 1) forState:UIControlStateDisabled];
        self.previewButton.titleLabel.font = FONT_WITH_20;
        [self.previewButton addTarget:self action:@selector(yulanCheakAction) forControlEvents:UIControlEventTouchUpInside];
        [self.previewButton sizeToFit];
        self.previewButton.left = 15;
        self.previewButton.centerY = _toolBar.height / 2;
        self.previewButton.enabled = (self.assetsChooses.count > 0) ? YES : NO;
        [_toolBar addSubview:self.previewButton];
        
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.finishButton setTitleColor:RGBCOLOR(150, 150, 150, 1) forState:UIControlStateDisabled];
        self.finishButton.titleLabel.font = FONT_WITH_20;
        [self.finishButton addTarget:self action:@selector(finichCheakAction) forControlEvents:UIControlEventTouchUpInside];
        [self.finishButton sizeToFit];
        self.finishButton.enabled = (self.assetsChooses.count > 0) ? YES : NO;
        self.finishButton.right = _toolBar.width - 15;
        self.finishButton.centerY = _toolBar.height / 2;
        [_toolBar addSubview:self.finishButton];
        
        CGFloat side = 20;
        self.circle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        self.circle.backgroundColor = UICOLOR_ARGB(0xff09bb07);
        self.circle.textColor = [UIColor whiteColor];
        [self.circle circleBorderWidth:0 borderColor:nil];
        self.circle.textAlignment = NSTextAlignmentCenter;
        self.circle.hidden = self.assetsChooses.count > 0 ? NO : YES;
        self.circle.userInteractionEnabled = NO;
        self.circle.text = self.assetsChooses.count > 0 ? STRING_FORMAT_ADC(@(self.assetsChooses.count)) : @"";
        self.circle.right = self.finishButton.left - 10;
        self.circle.centerY = _toolBar.height / 2 + 1;
        [_toolBar addSubview:self.circle];
    }
    return _toolBar;
}

#pragma mark ACTION
//预览
- (void)yulanCheakAction
{
    ARTPreviewViewController *preVC = [[ARTPreviewViewController alloc] initWithAssets:self.assetsChooses index:0];
    if (self.chooseBlock)
    {
        preVC.chooseBlock = self.chooseBlock;
    }
    [self.navigationController pushViewController:preVC animated:YES];
}

//完成
- (void)finichCheakAction
{
    if (self.chooseBlock)
    {
        self.chooseBlock(self.assetsChooses);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_backItemClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LOAD
- (void)loadAssets
{
    if (!self.assetsLibrary)
    {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    __weak __typeof(self) weak = self;
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                NSURL *url= (NSURL*)[[result defaultRepresentation] url];
                [weak.assetsLibrary assetForURL:url
                                    resultBlock:^(ALAsset *asset) {
                                        [weak.assets addObject:asset];
                                        [weak.collectionView reloadData];
                                    }
                                   failureBlock:^(NSError *error){
                                       
                                   }];
            }
        }
    };
    
    void (^ assetGroupEnumerator)( ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        [weak.view displayTostError:@"无法读取您的相册,请在「隐私设置」里设置"];
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:failureBlock];
}

#pragma mark DELEGATE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTAssetItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"assetcell" forIndexPath:indexPath];
    cell.delegate = self;
    ALAsset *asset = self.assets[indexPath.row];
    [cell update:asset isSelect:[self.assetsChooses containsObject:asset]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTAssetItem *cell = (ARTAssetItem *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell cheakAssetAction];
}

- (void)assetItemDidChooseImage:(ALAsset *)asset
{
    if ([self.assetsChooses containsObject:asset])
    {
        [self.assetsChooses removeObject:asset];
    }
    else
    {
        if (self.assetsChooses.count < self.multipleMax)
        {
            [self.assetsChooses addObject:asset];
        }
    }
    [self.collectionView reloadData];
    
    self.previewButton.enabled = (self.assetsChooses.count > 0) ? YES : NO;
    self.finishButton.enabled = (self.assetsChooses.count > 0) ? YES : NO;
    self.circle.hidden = self.assetsChooses.count > 0 ? NO : YES;
    self.circle.text = self.assetsChooses.count > 0 ? STRING_FORMAT_ADC(@(self.assetsChooses.count)) : @"";
    
}

@end
