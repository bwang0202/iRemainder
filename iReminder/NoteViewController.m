//
//  NoteViewController.m
//  iReminder
//
//  Created by Yuntian liu on 11/30/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "NoteViewController.h"
#import "CoorAnnotation.h"
#import "Note.h"
#import "Note+Create.h"
#import <MapKit/MapKit.h>

@interface NoteViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (weak, nonatomic) IBOutlet UITextView *detailss;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UIButton *dueDate;

@property (weak, nonatomic) IBOutlet UIButton *done;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewA;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewA;
@property (nonatomic)BOOL newDate;

@end

@implementation NoteViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show image"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setPhotoData:)]) {
            [segue.destinationViewController performSelector:@selector(setPhotoData:) withObject:self.note.photo];
        }
    }
}

-(void)setNote:(Note *)note
{
    _note = note;
    [self updateView];
}

-(void)updateView
{
    self.name.text = self.note.name;
    [self.progress setValue:[self.note.progress floatValue]];
    self.detailss.text = self.note.details;
    [self.dueDate setTitle:[self.note.dueDate description] forState:UIControlStateNormal];
    self.startDate.text= [self.note.createDate description];
    self.imageViewA.image = [UIImage imageWithData:self.note.photo];
    self.datePicker.hidden = true;
    self.datePicker.enabled = false;
    self.done.hidden =true;
    self.done.enabled = false;
    
    
}
- (IBAction)doneDatePick:(id)sender {
   // NSLog([self.datePicker.date description]);
    self.datePicker.enabled = false;
    self.datePicker.hidden = true;
    self.done.enabled = false;
    self.done.hidden = true;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.detailss.delegate = self;
    
    
    self.mapViewA.delegate = self;
    CoorAnnotation* anno;
    anno = [[CoorAnnotation alloc] initWithCoordinateLa:self.note.locationLa andWithLo:self.note.locationLo];
    anno.title = self.note.name;
    [self.mapViewA addAnnotation:anno];
    [self updateView];
    self.newDate = false;
}
- (IBAction)valueChanged:(id)sender {
    //change the progress of this note in data base
  //  NSLog(@"want to change progress bar");
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSMutableDictionary* noteDictionary = [[NSMutableDictionary alloc] init];
    [noteDictionary setValue:self.detailss.text forKey:@"details"];
    if (self.newDate) {
        [noteDictionary setValue:self.datePicker.date forKey:@"dueDate"];
    }else{
        [noteDictionary setValue:self.note.dueDate forKey:@"dueDate"];
    }
    [noteDictionary setValue:[NSNumber numberWithFloat:self.progress.value] forKey:@"progress"];
    [noteDictionary setValue:self.note.locationLa forKey:@"locationLa"];
    [noteDictionary setValue:self.note.locationLo forKey:@"locationLo"];
    [noteDictionary setValue:self.note.name forKey:@"name"];
    [noteDictionary setValue:self.note.createDate forKey:@"createDate"];
    [noteDictionary setValue:self.note.photo forKey:@"photo"];
    [Note noteWithDictionary:noteDictionary inManagedObjectContext:self.context ifUpdate:true];
    
}

- (IBAction)changeDueDate:(id)sender {
    //change a due date
   // NSLog(@"want to change due date");
    [self.dueDate setTitle:[self.datePicker.date description] forState:UIControlStateNormal];
    self.newDate = true;
    self.dueDate.selected = false;
    self.datePicker.hidden = false;
    self.datePicker.enabled = true;
    self.done.hidden = false;
    self.done.enabled = true;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    //change the detail of this note in database
   // NSLog(self.detailss.text);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
