//
//  ViewController.m
//  ImagePicker&CropDemo
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 luozhijun. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+imagePicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *targetImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.targetImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)]];
}

- (void)imageViewTapped
{
    // jepg图片压缩质量
    self.compressionQuality = @0.00001;
    
    self.editingImageView = self.targetImageView;
    self.imageCropMode = @(UIViewControllerImagePickerCropModeCircle);
    
    [self showImagePickerActionSheet];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    NSLog(@"%@", note);
}

@end
