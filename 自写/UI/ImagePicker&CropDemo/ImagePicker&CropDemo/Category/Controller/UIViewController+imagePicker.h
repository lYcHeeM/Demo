//
//  UIViewController+imagePicker.h
//  mobiportal
//
//  Created by luozhijun on 14-12-3.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//  给UIViewController选择图片的功能

#import <UIKit/UIKit.h>
#import "RSKImageCropper.h"

typedef enum {
    UIViewControllerImagePickerActionSheetTypeDefault,
    UIViewControllerImagePickerActionSheetTypeEdit
}UIViewControllerImagePickerActionSheetType;

typedef enum {
    UIViewControllerImagePickerEditingImageViewTagDefault,
    UIViewControllerImagePickerEditingImageViewTagEdited = 256
}UIViewControllerImagePickerEditingImageViewTag;

typedef enum {
    UIViewControllerImagePickerCropModeCircle,
    UIViewControllerImagePickerCropModeSquare,
    UIViewControllerImagePickerCropModeCustom
}UIViewControllerImagePickerCropMode;

/** 给UIViewController选择图片的功能 */
@interface UIViewController (imagePicker) <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate>
/** 压缩质量 */
@property (nonatomic, strong) NSNumber *compressionQuality;
/** 需要编辑的图片 */
@property (nonatomic, weak) UIImageView *editingImageView;
/** 图片截取的模式 */
@property (nonatomic, strong) NSNumber *imageCropMode;
/** 选择完图片时的回调 */
@property (nonatomic, copy) void (^didFinishPickingImageBlock)(UIImage *pickedImage);
/** 编辑完图片时的回调 */
@property (nonatomic, copy) void (^didFinishEditingImageBlock)(UIImage *pickedImage);


- (void)showImagePickerActionSheet;
- (void)showImagePickerActionSheetWithType:(UIViewControllerImagePickerActionSheetType)type;
@end
