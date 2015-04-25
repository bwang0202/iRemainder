//
//  MakeNoteViewController.h
//  iReminder
//
//  Created by Yuntian liu on 12/2/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>

@interface MakeNoteViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end
