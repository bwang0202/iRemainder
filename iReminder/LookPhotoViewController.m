//
//  LookPhotoViewController.m
//  iReminder
//
//  Created by Yuntian liu on 12/4/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "LookPhotoViewController.h"

@interface LookPhotoViewController ()

@property(strong, nonatomic)UIImageView* imageView;

@end

@implementation LookPhotoViewController

-(void)setPhotoData:(NSData *)photoData
{
    _photoData = photoData;
    [self resetImage];
}

-(UIImageView*) imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.delegate = self;
    [self resetImage];
}

-(void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        UIImage* image = [UIImage imageWithData:self.photoData];
        if (image) {
            
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [self autoZoom];
        }
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    [self autoZoom];
}

-(void)autoZoom
{
    //autozoom
    double scale1 = self.scrollView.bounds.size.width/self.imageView.frame.size.width;
    double scale2 = self.scrollView.bounds.size.height/self.imageView.frame.size.height;
    if ((self.imageView.frame.size.width != 0) && (self.imageView.frame.size.height !=0)) {
        if (scale1 < scale2) {
            self.scrollView.zoomScale = scale1;
            self.scrollView.minimumZoomScale = scale1;
        }else{
            self.scrollView.zoomScale = scale2;
            self.scrollView.minimumZoomScale = scale2;
        }
    }
}
@end
