//
//  MakeNoteViewController.m
//  iReminder
//
//  Created by Yuntian liu on 12/2/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "MakeNoteViewController.h"
#import "Note+Create.h"
//#import "ReminderManagedDocument.h"

@interface MakeNoteViewController ()
@property(strong, nonatomic)NSData* photoData;
@property(strong, nonatomic)NSManagedObjectContext* context;
@property(strong, nonatomic)CLLocationManager* manager;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;



@end

@implementation MakeNoteViewController

#pragma mark - CLLocation manager
- (IBAction)dismissTheKeyBoard:(id)sender {
    [self.view endEditing:true];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    CLLocationManager* manager = [[CLLocationManager alloc] init];
    self.manager = manager;
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLDistanceFilterNone;
    [manager startUpdatingLocation];
}


#pragma mark - managed object context

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.context) {
        [self useTagDocument];
    }
    //[self refresh];
}

-(void)useTagDocument{
        NSURL* url =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"tag document"];
        UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:url];
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            //create, async
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if (success) {
                    self.context = document.managedObjectContext;
                    //[self refresh];
                }
            }];
        }else if (document.documentState == UIDocumentStateClosed){
            //open
            [document openWithCompletionHandler:^(BOOL success){
                if (success) {
                    self.context = document.managedObjectContext;
                }
            }];
        }else{
            //use it
            self.context = document.managedObjectContext;
        }
        
        return;
}

- (IBAction)makeReminder:(id)sender {
    NSMutableDictionary* photoDictionary = [[NSMutableDictionary alloc] init];
    [photoDictionary setValue:self.photoData forKey:@"photo"];
    [photoDictionary setValue:[NSDate date] forKey:@"createDate"];
    CLLocationCoordinate2D coordinate;
    coordinate=[self.manager location].coordinate;
    NSLog(@"%f, %f",coordinate.latitude, coordinate.longitude);
    [photoDictionary setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"locationLa"];
    [photoDictionary setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"locationLo"];
    [photoDictionary setValue:[NSNumber numberWithFloat:self.progressSlider.value] forKey:@"progress"];
    [photoDictionary setValue:self.titleTextField.text forKey:@"name"];
    [photoDictionary setValue:self.detailTextField.text forKey:@"details"];
    [photoDictionary setValue:self.datePicker.date forKey:@"dueDate"];
    
    
    //
    [Note noteWithDictionary:photoDictionary inManagedObjectContext:self.context ifUpdate:true];
    //[self.context ]
    NSManagedObjectContext* c = self.context;
    __block BOOL success = YES;
    while (c && success) {
        [c performBlockAndWait:^{
            NSError* error;
            success = [c save:&error];
            //handle save success/failure
        }];
        c = c.parentContext;
    }
    [self.manager stopUpdatingLocation];
    
}


- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];    }
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSData* data = UIImagePNGRepresentation(image);
        self.photoData = data;
        self.myImageView.image = image;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
