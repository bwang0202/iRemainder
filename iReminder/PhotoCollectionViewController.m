//
//  PhotoCollectionViewController.m
//  iReminder
//
//  Created by Yuntian liu on 12/4/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "Note.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) NSArray* photos;
@property (strong, nonatomic) NSManagedObjectContext* context;
@end

@implementation PhotoCollectionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    if (!self.context) {
        [self useTagDocument];
    }
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

-(void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.predicate = nil;
    NSError* error = nil;
    NSMutableArray* photoArray = [[_context executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray* photot = [[NSMutableArray alloc] init];
   // NSLog(@"we now have %d fetchresult", photoArray.count);
    for (Note* note in photoArray) {
        if (note.photo) {
            //NSLog(@"found one photo");
            //[self.photos addObject:note.photo];
            NSData* data = note.photo;
            [photot addObject:data];
        }
    }
    self.photos = photot;
    [self.photoCollectionView reloadData];
}

#pragma UICollection view data source delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.photos.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    NSData* data = [self.photos objectAtIndex:indexPath.item];
    cell.imageView.image = [UIImage imageWithData:data];
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.photoCollectionView reloadData];
}
















@end
