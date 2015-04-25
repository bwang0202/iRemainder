//
//  NotesCDTVC.m
//  iReminder
//
//  Created by Yuntian liu on 12/2/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "NotesCDTVC.h"
#import "Note.h"
#import "ReminderTableViewCell.h"

@interface NotesCDTVC ()

@property(strong, nonatomic)NSNumber* flag;

@end

@implementation NotesCDTVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.flag = [NSNumber numberWithInt:1];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"showNote"]) {
            Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setNote:)]) {
                [segue.destinationViewController performSelector:@selector(setNote:) withObject:note];
                [segue.destinationViewController performSelector:@selector(setContext:) withObject:self.managedObjectContext];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [self useTagDocument];
    }
    [self.tableView reloadData];
}

-(void)useTagDocument
{
    NSURL* url =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"tag document"];
    UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:url];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        //create, async
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                //[self refresh];
            }
        }];
    }else if (document.documentState == UIDocumentStateClosed){
        //open
        [document openWithCompletionHandler:^(BOOL success){
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }else{
        //use it
        self.managedObjectContext = document.managedObjectContext;
    }
    //document
    return;
}
- (IBAction)sortByDueDate:(UIBarButtonItem *)sender {
    self.flag = [NSNumber numberWithInt:2];
    self.fetchedResultsController = nil;
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES selector:@selector(compare:)]];
        //request.predicate = nil; // all reminders
        request.predicate = [NSPredicate predicateWithFormat:@"progress > %@", [NSNumber numberWithFloat:0.0]]; // all undone reminders
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}
- (IBAction)sortByName:(UIBarButtonItem *)sender {
    self.flag = [NSNumber numberWithInt:1];
    self.fetchedResultsController = nil;
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all reminders
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}
- (IBAction)sortByWorkload:(UIBarButtonItem *)sender {
    self.flag = [NSNumber numberWithInt:3];
    self.fetchedResultsController = nil;
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:YES selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"progress > %@", [NSNumber numberWithFloat:0.0]]; // all undone reminders
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all reminders
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
   // [self.tableView reloadData];
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReminderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"note"];
    Note* note = [self.fetchedResultsController objectAtIndexPath:indexPath];
  //  cell.textLabel.text = note.name;
 //   cell.detailTextLabel.text = note.details;
    cell.titleTextField.text = note.name;
    if ([self.flag isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.detailTextField.text = note.details;
    }else if ([self.flag isEqualToNumber:[NSNumber numberWithInt:2]]){
        cell.detailTextField.text = [note.dueDate description];
    }else if ([self.flag isEqualToNumber:[NSNumber numberWithInt:3]]){
        cell.detailTextField.text = [NSString stringWithFormat:@"workload: %@", [note.progress description]];
    }
    
    return cell;
}

@end
