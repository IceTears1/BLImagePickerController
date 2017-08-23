//
//  BLPhotoGroupCell.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLPhotoGroupCell.h"
#import "BLPickerConfig.h"

@interface BLPhotoGroupCell()

@property (weak, nonatomic) IBOutlet UIImageView *kindImage;
@property (weak, nonatomic) IBOutlet UILabel *kindName;
@property (weak, nonatomic) IBOutlet UILabel *kindCount;



@end


@implementation BLPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)initCellWithDataSource:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)path {
    if (dataSource.count > path.row) {
        NSDictionary *data = dataSource[path.row];
        [self initCellWithDataSource:data];
    }
}

- (void)initCellWithDataSource:(NSDictionary *)dataDic {
    __weak BLPhotoGroupCell *weakSelf = self;
    PHFetchResult *result = dataDic[@"result"];
    NSString *title = dataDic[@"title"];
    NSString *count = dataDic[@"count"];
    self.kindName.text = [NSString stringWithFormat:@"%@(%@)",title,count];
    self.kindCount.text = @"";
    
    CGSize imageSize = CGSizeMake(200 , 200);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.networkAccessAllowed = YES;//允许从icloud 下载
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    if (result.count > 0) {
        PHAsset *asset = result.firstObject;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            weakSelf.kindImage.image = result;
            weakSelf.kindImage.image = [self getSubImage:result mCGRect:CGRectMake(0, 0, 200, 200) centerBool:YES];
        }];
    }


    
    
    
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




@end
