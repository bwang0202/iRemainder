//
//  ReminderTableViewCell.h
//  iReminder
//
//  Created by Yuntian liu on 12/3/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@end
