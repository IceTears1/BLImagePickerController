//
//  BLImagePickerViewController.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLImagePickerViewController.h"
#import "BLListCollectionViewCell.h"
#import "BLImageGroupViewController.h"
#import "BLTransitionAnimator.h"
#import "BLImageClipingViewController.h"
#import "BLPhotoListFooterView.h"
#import "BLPreviewImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BLListFooterReusableView.h"
@interface BLImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,BLListCollectionViewCellDelegate,BLImageGroupViewControllerDelegate,BLPhotoListFooterViewDelegate,BLPreviewImageViewControllerDelegate,BLImageClipingViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *leftBtn;
    UILabel *tipsLabel;
    BOOL isCancel;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet BLPhotoListFooterView *fooerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fooerViewHight;

@property (nonatomic, assign) BOOL cancelAllSelect;
@property (nonatomic, copy) PHFetchResult *result;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isOriginal;
@end

@implementation BLImagePickerViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        return  [[UIStoryboard storyboardWithName:@"BLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"BLImagePickerViewController"];
        
    }
    return self;
}
-(void)screenChanges{
    [super screenChanges];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
    CGRect frame = tipsLabel.frame;
    frame = CGRectMake(20, 150, SCREEN_WIDTH-20, 150);
    tipsLabel.frame = frame;
}
-(void)initDataProgress:(BLSelectImageLoading)progressBlock finished:(BLSelectImageFinishedBlock)finishedBlock cancle:(BLCancle)cancleBlock{
    _progressBlock = progressBlock;
    _finishedBlock = finishedBlock;
    _cancleBlock = cancleBlock;
    [[BLImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
    [[BLImageHelper shareImageHelper] getAllImageActionWithCollection:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cancelAllSelect = NO;
    [self.fooerView initFooterWithCount:[BLImageHelper shareImageHelper].phassetChoosedArr.count];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav1];
    [self initBaseData];
    [self setNav];
    [self.collectionView registerClass:[BLListFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BLListFooterReusableView"];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}
-(void)checkPhotoAbluPermissions{
    NSInteger i = [BLImageHelper shareImageHelper].photoAblumPermissions;
    if (i==-1) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self checkPhotoAbluPermissions];
        });
        
    }else if(i==0){
        [[BLImageHelper shareImageHelper] removeAllData];
        self.collectionView.hidden = YES;
        leftBtn.hidden = YES;
        tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH-40, 150)];
        
        tipsLabel.text = self.photoAlbumMassage;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:20];
        tipsLabel.numberOfLines = 0;
        [self.view addSubview:tipsLabel];
    }else{
        
        self.collectionView.hidden = NO;
        [[BLImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
        [[BLImageHelper shareImageHelper] getAllImageActionWithCollection:nil];
        [self.collectionView reloadData];
        
    }
    
}
-(void)initBaseData{
    
    [BLImageHelper shareImageHelper].currentGroupTitle = @"相机胶卷";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if(self.cameraMassage.length == 0){
        self.cameraMassage = [NSString stringWithFormat:@"无法获取相机功能请在%@的“设置-隐私-相机”选项中允许%@访问您的相机", self.isiPhone?@"iphone":@"ipad",app_Name];
    }
    if (self.photoAlbumMassage.length == 0) {
        self.photoAlbumMassage = [NSString stringWithFormat:@"无法获取相册功能请在%@的“设置-隐私-照片”选项中允许%@访问您的手机相册", self.isiPhone?@"iphone":@"ipad",app_Name];
    }
    
    [self checkPhotoAbluPermissions];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    if (self.maxNum<=0) {
        self.maxNum = 10;
    }
    if (self.maxNum == 1) {
        self.fooerViewHight.constant = 0.001;
        self.fooerView.hidden = YES;
    }else{
        self.fooerViewHight.constant = 45;
        self.fooerView.hidden = NO;
    }
    if (self.maxScale == 0) {
        self.maxScale = 2.0;
    }
    if (self.minScale == 0) {
        self.minScale = 1.0;
    }
    [BLImageHelper shareImageHelper].maxNum = self.maxNum;
    [BLImageHelper shareImageHelper].showCamera = self.showCamera;
    [BLImageHelper shareImageHelper].minScale = self.minScale;
    [BLImageHelper shareImageHelper].maxScale = self.maxScale;
}
-(void)setShowOrignal:(BOOL)showOrignal{
    [BLImageHelper shareImageHelper].showOrignal = showOrignal;
}
-(void)setShowOrignalBtn:(BOOL)showOrignalBtn{
    [BLImageHelper shareImageHelper].showOrignalBtn = showOrignalBtn;
}
#pragma mark    UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showCamera&&[BLImageHelper shareImageHelper].isAllphoto) {
        return [BLImageHelper shareImageHelper].phassetArr.count + 1;
    }else{
        return [BLImageHelper shareImageHelper].phassetArr.count;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section

{
    
    return CGSizeMake(0, 40);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionFooter) {
        BLListFooterReusableView *fooView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BLListFooterReusableView" forIndexPath:indexPath];
        
        fooView.label.text = [NSString stringWithFormat:@"共%lu张照片",(unsigned long)[BLImageHelper shareImageHelper].phassetArr.count];
        
        return fooView;
    }else{
        return nil;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLListCollectionViewCell" forIndexPath:indexPath];
    cell.isPad = self.isiPad;
    cell.delegate = self;
    cell.superVC = self;
    if(indexPath.item == 0 && self.showCamera && [BLImageHelper shareImageHelper].isAllphoto){
        cell.bgImage.image = [UIImage imageNamed:@"bl_camera"];
        cell.chooseBtn.hidden = YES;
        return cell;
    }else{
        cell.chooseBtn.hidden = NO;
        [cell initCellWithDataSource:[BLImageHelper shareImageHelper].phassetArr withIndexPath:indexPath isCancleAction:self.cancelAllSelect];
        
        return cell;
    }
}
#pragma mark    UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isiPad) {
        NSInteger num = SCREEN_WIDTH/CELL_COLLECTION_WIDTH;
        return CGSizeMake(CELL_COLLECTION_WIDTH - (num-1)*11/num , CELL_COLLECTION_WIDTH);
    }else{
        NSInteger num = SCREEN_WIDTH/CELL_COLLECTION_WIDTH_IPHONE;
        return CGSizeMake(CELL_COLLECTION_WIDTH_IPHONE - (num-1)*11/num, CELL_COLLECTION_WIDTH_IPHONE);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 && self.showCamera && [BLImageHelper shareImageHelper].isAllphoto) {
        [self openCamera];
    }else{
        PHAsset *asset;
        if (self.maxNum == 1) {
            if (self.showCamera && [BLImageHelper shareImageHelper].isAllphoto){
                asset = [BLImageHelper shareImageHelper].phassetArr[indexPath.item - 1];
            }else{
                asset = [BLImageHelper shareImageHelper].phassetArr[indexPath.item];
            }
            [[BLImageHelper shareImageHelper].phassetChoosedArr addObject:asset];
            [self sendData];
        }else{
            BLPreviewImageViewController *fullC = [[UIStoryboard storyboardWithName:@"BLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"BLPreviewImageViewController"];
            fullC.previewType = BL_PreviewAll;
            if (self.showCamera && [BLImageHelper shareImageHelper].isAllphoto){
                fullC.previewIndex = indexPath.item-1;
            }else{
                fullC.previewIndex = indexPath.item;
            }
            fullC.isOriginal = self.isOriginal;
            fullC.delegate = self;
            [self presentViewController:fullC animated:YES completion:nil];
        }
        
    }
    
}

#pragma mark 打开相机
- (void)openCamera
{
    if([[BLImageHelper shareImageHelper] cameraPermissions]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourceType;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.cameraMassage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo:(id)contextInfo {
    if(error){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"照片保存失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self saveImage:image];
    }
}
-(void)saveImage:(UIImage *)image{
    if (self.imageClipping&&self.maxNum == 1) {
        BLImageClipingViewController *vc = [[BLImageClipingViewController alloc]initWithImage:image cropFrame:self.clippingItemSize limitScaleRatio:(self.imageClippingScale == 0)?2.0:self.imageClippingScale];
        vc.delegate = self;
        [self.navigationController BL_pushViewController:vc AnimatorStyle:BLTransitionAnimatorBottom animated:NO];
    }else{
        if(self.maxNum == 1){
            [self exitImagePickerLib:@[image] assetArrt:@[[BLImageHelper shareImageHelper].getFirstObjectAllCollection] editedImage:nil];
        }else{
            PHAsset *assetString = [[BLImageHelper shareImageHelper] getFirstObjectAllCollection];
            
            [[BLImageHelper shareImageHelper].phassetArr insertObject:assetString atIndex:0];
            
            NSInteger selectCount = [BLImageHelper shareImageHelper].phassetChoosedArr.count;
            if (selectCount<self.maxNum) {
                assetString.chooseFlag = YES;
                [[BLImageHelper shareImageHelper].phassetChoosedArr addObject:assetString];
                [self.fooerView initFooterWithCount:[BLImageHelper shareImageHelper].phassetChoosedArr.count];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已经超过个数显示" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadData];
            }];
        }
    }
}

#pragma mark  当前页
//跳转我的相册
-(void)leftNavEvent
{
    BLImageGroupViewController  *imageGroup = [[UIStoryboard storyboardWithName:@"BLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"BLImageGroupViewController"];
    
    imageGroup.delegate = self;
    [self.navigationController BL_pushViewController:imageGroup AnimatorStyle:BLTransitionAnimatorLeft animated:YES];
}

//点击取消
-(void)rightBtnEvent{
    isCancel = YES;
    [self exitImagePickerLib:nil assetArrt:nil editedImage:nil];
}
//发送/预览
- (void)BL_photoListFooterViewTapWithType:(BLTapType)type {
    if (type == BLTapTypeSend) {
        
        [self sendData];
    }else {
        BLPreviewImageViewController *fullC = [[UIStoryboard storyboardWithName:@"BLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"BLPreviewImageViewController"];
        fullC.previewType = BL_PreviewSelect;
        fullC.delegate = self;
        if ([BLImageHelper shareImageHelper].phassetChoosedArr.count>0) {
            [self presentViewController:fullC animated:YES completion:nil];
        }
    }
}
-(void)BL_photoListFooterViewShowOriginal:(BOOL)isOriginal{
    self.isOriginal = isOriginal;
}
//cell的代理  刷新已选图片的个数
- (void)BL_imageHelperGetImageCount:(NSInteger)count {
    [self.fooerView initFooterWithCount:count];
}

#pragma mark   相册页面

//点击取消
-(void)BL_imageGroupClickCancel{
    //    NSLog(@"相册页面点击取消了");
    [[BLImageHelper shareImageHelper] removeAllData];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
//点击了相册
-(void)BL_imageGroupSelectImageGrou{
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
    if (self.navTitle.length!=0) {
        self.title = self.navTitle;
    }else{
        self.title = [BLImageHelper shareImageHelper].currentGroupTitle;
    }
}

#pragma mark    预览
//大图页面 的发送
-(void)BL_previewImageVCSendAction{
    
    [self sendData];
}
//点击预览页面选中按钮
-(void)BL_previewImageVCRefreshType:(BL_PreviewImageType)previewType Item:(NSIndexPath *)indexPath{
    //    DDLOG(@"%ld",indexPath.item);
    NSIndexPath *index;
    if (self.showCamera && [BLImageHelper shareImageHelper].isAllphoto){
        index = [NSIndexPath indexPathForItem:indexPath.item+1 inSection:indexPath.section];
    }else{
        index = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
    }
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[index]];
        
    }];
}
#pragma mark   剪切图片
- (void)imageCliping:(BLImageClipingViewController *)clipingViewController didFinished:(UIImage *)editedImage{
    [self exitImagePickerLib:nil assetArrt:nil editedImage:editedImage];
}

#pragma mark   跳转切图页面
-(void)jumpClippingVc:(PHAsset*) asset{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = YES;//允许从icloud 下载
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                BLImageClipingViewController *vc = [[BLImageClipingViewController alloc]initWithImage:result cropFrame:weakSelf.clippingItemSize limitScaleRatio:(self.imageClippingScale == 0)?2.0:self.imageClippingScale];
                vc.delegate = weakSelf;
                [weakSelf.navigationController BL_pushViewController:vc AnimatorStyle:BLTransitionAnimatorBottom animated:NO];
            });
            
            
        }];
    });
    
    
}

#pragma mark    发送图片
-(void)sendData{
    if ([[BLImageHelper shareImageHelper].phassetChoosedArr count]== 0) {
        return;
    }
    
    if(self.imageClipping&&[[BLImageHelper shareImageHelper].phassetChoosedArr count]==1&&self.maxNum == 1){
        PHAsset *asset = [BLImageHelper shareImageHelper].phassetChoosedArr.firstObject;
        [self jumpClippingVc:asset];
        return;
    }
    
    //    DDLOG(@"%@____已选的照片发送",  [BLImageHelper shareImageHelper].phassetChoosedArr);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;//允许从icloud 下载
    NSMutableArray *mAry = [[NSMutableArray alloc]initWithCapacity:0];
    if (self.progressBlock) {
        self.progressBlock(0);
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger i=1;
        for (PHAsset *asset in [BLImageHelper shareImageHelper].phassetChoosedArr) {
            CGSize imageSize = self.itemSize;
            if ((self.itemSize.width > 0)&&(self.itemSize.height > 0)) {
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [mAry addObject:result];
                }];
            }else{
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [mAry addObject:result];
                }];
            }
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.progressBlock) {
                    self.progressBlock(i/(CGFloat)[BLImageHelper shareImageHelper].phassetChoosedArr.count);
                }
            });
            i++;
        }
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exitImagePickerLib:mAry assetArrt:[BLImageHelper shareImageHelper].phassetChoosedArr editedImage:nil];
        });
    });
    
    
    
}
//退出图片选择器
-(void)exitImagePickerLib:(NSArray*)selectAry assetArrt:(NSArray*)assetArry editedImage:(UIImage *)image{
    if (isCancel) {
        _cancleBlock(@"取消");
    }else{
        if (self.finishedBlock) {
            _finishedBlock(selectAry,assetArry,image);
        }
    }
    [[BLImageHelper shareImageHelper] removeAllData];
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (void)setNav{
    if(self.navTitle.length != 0){
        self.title =self.navTitle;
    }else{
        self.title =[BLImageHelper shareImageHelper].currentGroupTitle;
    }
    if(self.navColor){
        self.navigationController.navigationBar.barTintColor=self.navColor;
    }else{
        
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:230/255.0 green:47/255.0 blue:23/255.0 alpha:1.0];
    }
    if(self.navTitleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :self.navTitleColor}];
        self.navigationController.navigationBar.tintColor= self.navTitleColor;
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
    }
}
- (void)createNav1{
    
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    leftBtn.backgroundColor = [UIColor greenColor];
    [leftBtn setTitle:@"相册" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"nav_ic_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"nav_ic_back"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftNavEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnEvent)];
}

- (void)setFooerView:(BLPhotoListFooterView *)fooerView {
    _fooerView = fooerView;
    _fooerView.delegate = self;
}

-(void)disPlayCurVerson{
    DDLOG(@"-----------------------------------------BLImagePickerLib----------------------------------------");
    DDLOG(@"-----------------------------------------------V%@--------------------------------------------",curVerson);
    DDLOG(@"-------------------git:%@----------------------",@"https://github.com/IceTears1/BLImagePickerController");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
