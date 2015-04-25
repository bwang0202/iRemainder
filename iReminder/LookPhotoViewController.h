//
//  LookPhotoViewController.h
//  iReminder
//
//  Created by Yuntian liu on 12/4/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookPhotoViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)NSData* photoData;

@end
