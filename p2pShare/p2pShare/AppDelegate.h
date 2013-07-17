//
//  AppDelegate.h
//  p2pShare
//
//  Created by jacob on 12/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    HTTPServer *httpServer;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

@end
