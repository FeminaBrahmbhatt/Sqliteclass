//
//  DBMethods.h
//  SQLlite Demo
//
//  Created by Femina Rajesh Brahmbhatt on 15/07/17.
//  Copyright © 2017 Femina Rajesh Brahmbhatt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <UIKit/UIKit.h>
@interface DBMethods : NSObject

//_====================================================  Database Methods
/*
 To get the path of databse file
 */
+ (NSString*)pathOfDatabse;
/*
 Database select method
 To get the data from database using query
 */
+ (NSMutableArray*)selectFromDBwithSelectQuery:(NSString*)query;
/*
 Database Insert method
 To insert or edit entry in table using query
 */
+ (BOOL)editFromDBwithQuery:(NSString*)query;
/*
 Database count method
 To get rowcount of fetched data using query
 */
+(int)getRowCountFromDatabaseWithQry:(NSString*)query;
/*
 Database add columnn method
 To addcolumn into the table
 */
+(void)addcoloumn:(NSString*)columnname intotable:(NSString*)tablename;

//_====================================================  Database Error Message
+(void)errorInDatabase:(NSString*)errorMgs;

@end
