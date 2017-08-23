//
//  BLListCollectionViewCell.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLListCollectionViewCell.h"
#import "BLPickerConfig.h"

@interface BLListCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIButton *chooseState;

@property (nonatomic, strong) PHAsset *tempAsset;


@end

@implementation BLListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bringSubviewToFront:self.chooseState];
    self.bgImage.userInteractionEnabled = YES;
}

- (void)initCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath isCancleAction:(BOOL)cancleAction {
    NSInteger maxNumTemp= [BLImageHelper shareImageHelper].maxNum;
    if(maxNumTemp == 1) {
        self.chooseBtn.hidden = YES;
    }else{
        self.chooseBtn.hidden = NO;
    }
    self.IndexPath = indexPath;
    PHAsset *assetString;
    if([BLImageHelper shareImageHelper].showCamera && [BLImageHelper shareImageHelper].isAllphoto){
        assetString = dataSource[indexPath.row-1];
    }else{
        assetString = dataSource[indexPath.row];
    }
    
    [self initCellWithAssetString:assetString isCancleAction:cancleAction];
    
}


- (void)initCellWithAssetString:(PHAsset *)asset  isCancleAction:(BOOL)cancleAction{
    __weak typeof(self) weakSelf = self;
    self.tempAsset = (PHAsset *)asset;
    if (!cancleAction) {
        if (asset.chooseFlag ) {
            self.chooseState.selected = YES;
            [self.chooseState setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        }else {
            self.chooseState.selected = NO;
            [self.chooseState setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
        }
    }else {
        asset.chooseFlag = NO;
        self.chooseState.selected = NO;
        [self.chooseState setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
    }
    CGSize imageSize;
    if (self.isPad) {
        imageSize = CGSizeMake(CELL_COLLECTION_WIDTH*1.5, CELL_COLLECTION_WIDTH*1.5);
    }else{
        imageSize = CGSizeMake(CELL_COLLECTION_WIDTH_IPHONE*1.5, CELL_COLLECTION_WIDTH_IPHONE*1.5);
    }
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.networkAccessAllowed = YES;//允许从icloud 下载
    /*
     1.Opportunistic表示尽可能的获取高质量图片
     2.HighQualityFormat表示不管花多少时间也要获取高质量的图片(慎用)
     3.FastFormat快速获取图片,(图片质量低,我们通常设置这种来获取缩略图)
     */
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    options.resizeMode = PHImageRequestOptionsResizeModeExact;//提供精准大小的图片
    
    //创建串行队列
    @autoreleasepool {
        dispatch_async(dispatch_queue_create("queue", NULL), ^{
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.photoImage.image = result;
                });
                
             }];
            
        });

    }
    
}

-(void)releaseStr:(NSString *)str{
    str = nil;
}

//#pragma mark    根据标志符取出PHFetchResult
//- (PHFetchResult *)getPHFetchResultFromAssetString:(NSString *)assetString {
//    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetString] options:nil];
//}




#pragma mark    interFaceBuilder Method
- (IBAction)tapAction:(UIButton *)sender {
    self.chooseState.selected = !self.chooseState.selected;
    if (self.chooseState.selected) {
        
        NSInteger maxNumTemp= [BLImageHelper shareImageHelper].maxNum;
        NSInteger selectCount = [BLImageHelper shareImageHelper].phassetChoosedArr.count;
        
        if(selectCount>=maxNumTemp){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已经超过个数限制" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self.superVC presentViewController:alert animated:YES completion:nil];
        }else{
            [self.chooseState setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
            self.tempAsset.chooseFlag = YES;
            [[BLImageHelper shareImageHelper].phassetChoosedArr addObject:self.tempAsset];
            [self animationAction];
        }
    }else {
        [self.chooseState setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
        self.tempAsset.chooseFlag = NO;
        [[BLImageHelper shareImageHelper].phassetChoosedArr removeObject:self.tempAsset];
    }
    [self.delegate BL_imageHelperGetImageCount:[BLImageHelper shareImageHelper].phassetChoosedArr.count];
    [self.chooseState setNeedsLayout];
    
}

#pragma mark    按钮动画
- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1.05), @(1.1), @(1.15),@(1.1), @(1.05), @(1), @(1.05), @(1.1), @(1.15),@(1.1), @(1.05),@(1)];
    [self.chooseState.imageView.layer addAnimation:animation forKey:@"animation"];
    
}
//截取正方形的图片 centerBool为YES  表示从中心开始截取
-(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    float viewWidth = mCGRect.size.width;
    float viewHidth = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgWidth-viewWidth)/2,(imgHeight-viewHidth)/2,viewWidth,viewHidth);
    else{
        if(viewHidth<viewWidth)
        {
            if(imgWidth<= imgHeight)
            {
                rect=CGRectMake(0, 0,imgWidth, imgWidth*viewHidth/viewWidth);
            }else
            {
                float width = viewWidth*imgHeight/viewHidth;
                float x = (imgWidth  - width)/2;
                if(x>0)
                {
                    rect = CGRectMake(x,0,  width, imgHeight);
                }else
                {
                    rect =  CGRectMake(0,  0,  imgWidth, imgWidth*viewHidth/viewWidth);
                }
            }
        }else
        {
            if(imgWidth <= imgHeight)
            {
                float height = viewHidth*imgWidth/viewWidth;
                if(height< imgHeight)
                {
                    rect =CGRectMake(0,  0, imgWidth, height);
                }else
                {
                    rect = CGRectMake(0,  0,viewWidth*imgHeight/viewHidth, imgHeight);
                }
            }else
            {
                float width = viewWidth*imgHeight/viewHidth;
                if(width< imgWidth)
                {
                    float x =  (imgWidth - width)/2;
                    rect =CGRectMake(x,  0,width, imgHeight);
                }else
                {
                    rect =CGRectMake(0,  0,imgWidth, imgHeight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage,rect);
    CGRect smallBounds =CGRectMake(0, 0,CGImageGetWidth(subImageRef),CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size); CGContextRef context =UIGraphicsGetCurrentContext();CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage =[UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

- (void)dealloc {
    [self.chooseState.imageView.layer removeAnimationForKey:@"animation"];
    [self.chooseState.imageView.layer removeAllAnimations];
//    DDLOG(@"asdasd");
    //    NSLog(@"[%@---------------dealloc]", self.class);
}


@end
