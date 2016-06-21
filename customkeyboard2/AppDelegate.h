//
//  AppDelegate.h
//  CustomKeyboard2
//
//  Created by Simon Smiley-Andrews on 09/04/2015.
//  Copyright (c) 2015 Simon Smiley-Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (UIColor*)colorWithHexString:(NSString*)hex;
+ (AppDelegate *)sharedAppDelegate;
@end

