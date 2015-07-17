//
//  Person.h
//  ASSnippets
//
//  Created by Atif Saeed on 7/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;

@end

/*
 
 // delete
 
 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([tableName class])];
 NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"tableName"];

 NSError *error = nil;
 NSArray *resultArray = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
 
 for(id object in resultArray){
 [[self managedObjectContext] deleteObject:object];
 }
 
 // add
 saved = [[self managedObjectContext] save:&error];
 
 if (!saved) {
 return saved;
 }
 
 for (NSDictionary *dictionary in resultArray) {
 
 
 ClassName *instance = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ClassName class]) inManagedObjectContext:self.managedObjectContext];
 NSOBJECTClass *objectInstace = [[NSOBJECTClass alloc] dictionary];

 instance.objectInstace1 = @([objectInstace.ID intValue]);
 instance.objectInstace2 = objectInstace.name;
 }
 
 saved = [self.managedObjectContext save:&error];
 if(saved) {
    NSLog(@"save sucessfully");
 } else {
    NSLog(@"Error = %@", error);
 }
 
 return saved;
 
 */