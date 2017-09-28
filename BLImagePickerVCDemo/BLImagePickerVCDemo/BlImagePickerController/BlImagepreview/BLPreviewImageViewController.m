//
//  BLPreviewImageViewController.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import "BLPreviewImageViewController.h"
#import "BLPreviewImageCell.h"
#import "BLPreviewImageFooterView.h"
#import "BLPreviewImageHeaderView.h"
#import "BLPickerConfig.h"

@interface BLPreviewImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BLPreviewImageHeaderViewDelegate, UIScrollViewDelegate, BLPreviewImageFooterViewDelegate,BLPreviewImageCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet BLPreviewImageHeaderView *topView;

@property (weak, nonatomic) IBOutlet BLPreviewImageFooterView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHight;

@property (nonatomic, assign) NSInteger scrollFlag;



@end

@implementation BLPreviewImageViewController
-(void)screenChanges{
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.previewIndex inSection:0]]];
        
    }];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.previewIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if (self.previewType == BL_PreviewAll) {
        
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetArr withIndexPath:[NSIndexPath indexPathForItem:self.previewIndex inSection:0]];
    }else {
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetChoosedArr withIndexPath:[NSIndexPath indexPathForItem:self.previewIndex inSection:0]];
        
    }
    
    //    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //     [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetArr withIndexPath:[NSIndexPath indexPathForItem:self.previewIndex inSection:0]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    //    self.isOriginal = YES;
    if(IOS11){
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (is_iPhoneX) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.headerVIewHight.constant = 88;
        self.topViewTop.constant = -44;
    }
    self.scrollFlag = 1;
    [self.footerView initFooterWithCount:[BLImageHelper shareImageHelper].phassetChoosedArr.count];
    if (self.previewType == BL_PreviewAll) {
        self.topView.chooseButton.hidden = NO;
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetArr withIndexPath:[NSIndexPath indexPathForItem:self.previewIndex inSection:0]];
    }else {
        self.topView.chooseButton.hidden = YES;
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetChoosedArr withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
    }
    
}
#pragma mark    纯代码创建此界面无需这么麻烦:直接调用scrollToItemAtIndexPath方法即可实现效果;
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.previewType == BL_PreviewAll && self.scrollFlag == 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.previewIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.scrollFlag = 999;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x / SCREEN_WIDTH;
    NSIndexPath *path = [NSIndexPath indexPathForItem:round(offset) inSection:0];
    self.previewIndex = path.item;
    if (self.previewType == BL_PreviewAll) {
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetArr withIndexPath:path];
    }else {
        [self.topView initHeaderWihtDataSource:[BLImageHelper shareImageHelper].phassetChoosedArr withIndexPath:path];
    }
}


#pragma mark    UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.previewType == BL_PreviewAll) {
        return [BLImageHelper shareImageHelper].phassetArr.count;
    }else {
        return [BLImageHelper shareImageHelper].phassetChoosedArr.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLPreviewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLPreviewImageCell" forIndexPath:indexPath];
    cell.scrollView.zoomScale = 1;
    cell.delegate = self;
    //    [cell.scrollView  setContentOffset:CGPointMake(0, 0)];
    if (self.previewType == BL_PreviewAll) {
        [cell initDataSource:[BLImageHelper shareImageHelper].phassetArr inedexPath:indexPath isOriginalImage:self.isOriginal];
    }else {
        [cell initDataSource:[BLImageHelper shareImageHelper].phassetChoosedArr inedexPath:indexPath isOriginalImage:self.isOriginal];
    }
    return cell;
}

#pragma mark    UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iPhoneX) {
        return CGSizeMake(SCREEN_WIDTH-0.001*2 , SCREEN_HEIGHT-24);
        
    }else{
        return CGSizeMake(SCREEN_WIDTH-0.001*2 , SCREEN_HEIGHT-45);
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

#pragma mark  手势事件
-(void)Bl_previewImageCollectionViewCellSingleRecognizer{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.topView.alpha = weakSelf.footerView.alpha = weakSelf.footerView.hidden;
        weakSelf.topView.hidden = !weakSelf.topView.hidden;
        weakSelf.footerView.hidden = !weakSelf.footerView.hidden;
        if(weakSelf.footerView.hidden){
            weakSelf.footerViewHight.constant = 0;
        }else{
            if (is_iPhoneX) {
                weakSelf.footerViewHight.constant = 45;
                
            }else{
                weakSelf.footerViewHight.constant = 45;
            }
            
        }
    }];
    
}

#pragma mark    头部view 返回按钮和 选择 按钮代理

- (void)BL_previewImageHeaderViewTapDismissAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)BL_previewImageHeaderViewTapChangeChooseStatusAction {
    [self.footerView initFooterWithCount:[BLImageHelper shareImageHelper].phassetChoosedArr.count];
    
}
-(void)BL_previewImageRefreshItem:(NSIndexPath *)indexPath{
    
    if (self.delegate) {
        [self.delegate BL_previewImageVCRefreshType:self.previewType Item:indexPath];
    }
    //    PHAsset *assetString = [BLImageHelper shareImageHelper].phassetArr[indexPath.row];
    //    assetString.chooseFlag = NO;
    //    [[BLImageHelper shareImageHelper].phassetArr replaceObjectAtIndex:indexPath.row withObject:assetString];
    //    [UIView performWithoutAnimation:^{
    //        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //    }];
    
}
#pragma mark    底部view 发送按钮代理
- (void)BL_chooseImageSendAction {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.delegate) {
        [self.delegate BL_previewImageVCSendAction];
    }
}


#pragma mark    设置代理
- (void)setTopView:(BLPreviewImageHeaderView *)topView {
    _topView = topView;
    _topView.delegate = self;
    _topView.superVC = self;
}

- (void)setFooterView:(BLPreviewImageFooterView *)footerView {
    _footerView = footerView;
    _footerView.delegate = self;
}


- (void)dealloc {
    //    NSLog(@"[%@--dealloc]", self.class);
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
