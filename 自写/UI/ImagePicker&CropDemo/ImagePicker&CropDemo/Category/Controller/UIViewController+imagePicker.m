//
//  UIViewController+imagePicker.m
//  mobiportal
//
//  Created by luozhijun on 14-12-3.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//


#import "UIViewController+imagePicker.h"
#import <objc/runtime.h>

static const CGFloat ZJImageDefaultCompressionQuality = 0.0001;

@implementation UIViewController (imagePicker) 

static const void *compressionQualityKey = &compressionQualityKey;
static const void *didFinishPickingImageBlockKey = &didFinishPickingImageBlockKey;
static const void *editingImageViewKey = &editingImageViewKey;
static const void *imageCropModeKey = &imageCropModeKey;;
static const void *didFinishEditingImageBlockKey = &didFinishEditingImageBlockKey;

#pragma mark - -extentedProperty

- (void)setCompressionQuality:(NSNumber *)compressionQuality
{
    objc_setAssociatedObject(self, compressionQualityKey, compressionQuality, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)compressionQuality
{
    return objc_getAssociatedObject(self, compressionQualityKey);
}

- (void)setDidFinishPickingImageBlock:(void (^)(UIImage *))didFinishPickingImageBlock
{
    objc_setAssociatedObject(self, didFinishPickingImageBlockKey, didFinishPickingImageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIImage *))didFinishPickingImageBlock
{
    return objc_getAssociatedObject(self, didFinishPickingImageBlockKey);
}

- (void)setEditingImageView:(UIImageView *)editingImageView
{
    objc_setAssociatedObject(self, editingImageViewKey, editingImageView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIImageView *)editingImageView
{
    return objc_getAssociatedObject(self, editingImageViewKey);
}

- (void)setImageCropMode:(NSNumber *)imageCropMode
{
    objc_setAssociatedObject(self, imageCropModeKey, imageCropMode, OBJC_ASSOCIATION_ASSIGN);
}

- (NSNumber *)imageCropMode
{
    return objc_getAssociatedObject(self, imageCropModeKey);
}

- (void)setDidFinishEditingImageBlock:(void (^)(UIImage *))didFinishEditingImageBlock
{
    objc_setAssociatedObject(self, didFinishEditingImageBlockKey, didFinishEditingImageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIImage *))didFinishEditingImageBlock
{
    return objc_getAssociatedObject(self, didFinishEditingImageBlockKey);
}

#pragma mark - -public
- (void)showImagePickerActionSheet
{
    if (self.editingImageView.tag == UIViewControllerImagePickerEditingImageViewTagDefault) {
        [self showImagePickerActionSheetWithType:UIViewControllerImagePickerActionSheetTypeDefault];
    } else {
        [self showImagePickerActionSheetWithType:UIViewControllerImagePickerActionSheetTypeEdit];
    }
}

- (void)showImagePickerActionSheetWithType:(UIViewControllerImagePickerActionSheetType)type
{
    UIActionSheet *sheet = nil;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    if (type == UIViewControllerImagePickerActionSheetTypeEdit) {
        [sheet addButtonWithTitle:@"编辑当前照片"];
    }
    
    sheet.tag = 255;

    [sheet showInView:self.view];
    self.view updateConstraints
}


#pragma mark - -action sheet delegte

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 3: //编辑
                    [self switchToImageCroperViewControllerWithImage:self.editingImageView.image];
                    return;
                default:
                    break;
            }
        }
        else { // 不支持相机
            switch (buttonIndex) {
                case 0:
                    return;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    break;
                case 2:
                    [self switchToImageCroperViewControllerWithImage:self.editingImageView.image];
                    return;
                default:
                    break;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (void)switchToImageCroperViewControllerWithImage:(UIImage *)image
{
    RSKImageCropViewController *cropVc = [[RSKImageCropViewController alloc] initWithImage:image cropMode:self.imageCropMode.integerValue];
    cropVc.delegate = self;
    if (self.navigationController) {
        [self.navigationController pushViewController:cropVc animated:NO];
    } else {
        [self presentViewController:cropVc animated:YES completion:nil];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, self.compressionQuality ? self.compressionQuality.doubleValue : ZJImageDefaultCompressionQuality);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    if (self.didFinishPickingImageBlock) {
        self.didFinishPickingImageBlock(compressedImage);
    }
    
    // 跳到图片编辑控制器
    [self switchToImageCroperViewControllerWithImage:compressedImage];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    self.editingImageView.image = croppedImage;
    
    // 修改tag
    self.editingImageView.tag = UIViewControllerImagePickerEditingImageViewTagEdited;
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    
    // 通知图片编辑完成 并传值
    if (self.didFinishEditingImageBlock) {
        self.didFinishEditingImageBlock(croppedImage);
    }
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
