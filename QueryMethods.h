//
//  QueryMethods.h
//  SQLlite Demo
//
//  Created by Femina Rajesh Brahmbhatt on 15/07/17.
//  Copyright © 2017 Femina Rajesh Brahmbhatt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBMethods.h"
@interface QueryMethods : NSObject

/*!
 @brief Insert record into table
 
 @discussion

 @param table Name of the table in which record is to be inserted
 @param field Name of the fields to be inserted seprated by ,
 @param values Values of the fields seprated by ,
 
 @return
 */
+(BOOL)insertIntoTable:(NSString*)table WithFields:(NSString*)field andValues:(NSString*)values;
/*!
 @brief Delete records from table
 
 @discussion
 
 @param table Name of the table from which record is to be deleted
 @param condition to filter the type of records to be deleted
 
 @return
 */
+(BOOL)deleteFrom:(NSString*)table Where:(NSString*)condition;
/*!
 @brief select records from table
 
 @discussion
 
 @param table Name of the table from which record is to be selected
 @param condition to filter the type of records to be selected
 
 @return
 */
+(NSMutableArray*)selectFrom:(NSString*)table Where:(NSString*)condition;
/*!
 @brief select records from table
 
 @discussion
 
 @param table Name of the table from which record is to be selected
 @param condition to filter the type of records to be selected
 @param order to sort records by a filed in specific order.
 
 @return
 */
+(NSMutableArray*)selectFrom:(NSString*)table Where:(NSString*)condition orderBy:(NSString*)order;
/*!
 @brief update records from table
 
 @discussion
 
 @param table Name of the table from which record is to be updated
 @param condition to filter the type of records to be updated
 @param setString to specify the fields and the new value that is to be updated
 
 @return
 */
+(BOOL)update:(NSString*)table set:(NSString*)setString Where:(NSString*)condition;
/*!
 @brief Get record count
 
 @discussion

 @param table Name of the table from which record is to be counted
 @param condition to filter the type of records to be counted
 
 @return
 */
+(int)getcountFor:(NSString*)table Where:(NSString*)condition;
/*!
 @brief to make string valid for SQL execution
 
 @discussion Fixes a value so that it is valid for the sql execution and doesn't generate an error
 
 @param msg the string to be validates
 
 @return Resulted string which is valid for sql execution as NSString
 */
+(NSString*)decodeStringforSQL:(NSString*)msg;

@end
