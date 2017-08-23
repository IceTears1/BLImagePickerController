//
//  BLPreviewImageCell.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import "BLPreviewImageCell.h"
#import "BLPickerConfig.h"

@interface BLPreviewImageCell()<UIScrollViewDelegate>

{
    CGFloat curScale;
}

@end

@implementation BLPreviewImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.maximumZoomScale = [BLImageHelper shareImageHelper].maxScale;
    self.scrollView.minimumZoomScale = [BLImageHelper shareImageHelper].minScale;
    self.scrollView.bouncesZoom = YES;
    
    curScale = 1.0;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap1:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleRecognizer];
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
}
-(void)singleTap1:(UITapGestureRecognizer*)recognizer
{
    
    if(self.delegate){
        [self.delegate Bl_previewImageCollectionViewCellSingleRecognizer];
    }
    
}
-(void)doubleTap:(UITapGestureRecognizer*)recognizer
{
    
    if(curScale == 1.0) {
        [self.scrollView setZoomScale:[BLImageHelper shareImageHelper].maxScale animated:YES];
    }else{
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

// 缩放时调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    curScale = scrollView.zoomScale;
    // 可以实时监测缩放比例
    if(scrollView.zoomScale<=1.0){
        self.fullImage.center = scrollView.center;
    }
}

#pragma mark    UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView; {
    return self.fullImage;
}

- (void)initDataSource:(NSMutableArray *)dataSource inedexPath:(NSIndexPath *)indexPath isOriginalImage:(BOOL)isOriginal{
    if (dataSource.count > indexPath.row) {
        PHAsset *asset = dataSource[indexPath.row];
        [self initCellWtihPHAsseet:asset isOriginalImage:isOriginal];
    }
}


/**
 
 asset，图像对应的 PHAsset。
 targetSize，需要获取的图像的尺寸，如果输入的尺寸大于资源原图的尺寸，则只返回原图。
 需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量?
 PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸。
 contentMode，图像的剪裁方式，与?UIView 的 contentMode 参数相似，控制照片应该以按比例缩放还是按比例填充的方式放到最终展示的容器内。
 注意如果 targetSize 传入?PHImageManagerMaximumSize，则 contentMode 无论传入什么值都会被视为?PHImageContentModeDefault。
 options，一个?PHImageRequestOptions 的实例，可以控制的内容相当丰富，包括图像的质量、版本，也会有参数控制图像的剪裁，下面再展开说明。
 resultHandler，请求结束后被调用的 block，返回一个包含资源对于图像的 UIImage 和包含图像信息的一个 NSDictionary，在整个请求的周期中，这个 block 可能会被多次调用，关于这点连同 options 参数在下面展开说明。
 
 
 */

//#warning 整张图片显示时,如果限制张数可将"imageSize"换成PHImageManagerMaximumSize; 这样会显示高清的原图;

- (void)initCellWtihPHAsseet:(PHAsset *)phasset isOriginalImage:(BOOL)isOriginal{
    __weak BLPreviewImageCell *weakSelf = self;
    
    CGSize imageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.networkAccessAllowed = YES;//允许从icloud 下载
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    if ([BLImageHelper shareImageHelper].showOrignal) {
        isOriginal = YES;
    }
    //  后台执行：
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    if (isOriginal) {
        
        // 查看原图功能,慎重使用.大图占用内存大
        [[PHImageManager defaultManager] requestImageForAsset:phasset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.fullImage.image = result;
            });
            
        }];
    }else {
        [[PHImageManager defaultManager] requestImageForAsset:phasset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.fullImage.image = result;
                // DDLOG(@"%@",NSStringFromCGSize(result.size));
            });
        }];
    }
    //    });
    
    
}




@end
