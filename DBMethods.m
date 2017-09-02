//
//  DBMethods.m
//  SQLlite Demo
//
//  Created by Femina Rajesh Brahmbhatt on 15/07/17.
//  Copyright © 2017 Femina Rajesh Brahmbhatt. All rights reserved.
//

#import "DBMethods.h"
#define dbnanme @"stock.sqlite"
@implementation DBMethods

#pragma mark - Database Methods
+ (NSString*)pathOfDatabse;
{
    NSString *str_dbname = dbnanme;
    
    NSArray *documentdir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *str_dbpath = [[documentdir objectAtIndex:0] stringByAppendingString:str_dbname];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if (![filemanager fileExistsAtPath:str_dbpath]) {
        NSString *dbpath_reset = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:dbnanme];
        [filemanager removeItemAtPath:str_dbpath error:nil];
        [filemanager copyItemAtPath:dbpath_reset toPath:str_dbpath error:nil];
    }
    
    return str_dbpath;
}

+ (NSMutableArray*)selectFromDBwithSelectQuery:(NSString*)query
{
    NSMutableArray *db_arr = [[NSMutableArray alloc]init];
    NSString *str_dbpath = [self pathOfDatabse];
    sqlite3 *databse;
    sqlite3_stmt *compiled_stmt = NULL;
    const char *querystmnt = [query UTF8String];
    
    if (sqlite3_open([str_dbpath UTF8String], &databse)==SQLITE_OK) {
        
        if (sqlite3_prepare_v2(databse, querystmnt, -1, &compiled_stmt, NULL)==SQLITE_OK) {
            
            NSInteger numberofcoulumns = sqlite3_column_count(compiled_stmt);
            NSMutableArray *arr_columnnames = [[NSMutableArray alloc]init];
            
            for (int counter = 0; counter<numberofcoulumns; counter++) {
                [arr_columnnames addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_name(compiled_stmt, counter)]];
            }
            
            while (sqlite3_step(compiled_stmt) == SQLITE_ROW) {
                NSMutableDictionary *rowvalue = [[NSMutableDictionary alloc]init];
                
                for (int counter = 0; counter<numberofcoulumns; counter++) {
                    if (sqlite3_column_type(compiled_stmt, counter) == SQLITE_INTEGER) {
                        NSString *str_ColumnInt = [NSString stringWithFormat:@"%d",sqlite3_column_int(compiled_stmt, counter)];
                        [rowvalue setObject:str_ColumnInt forKey:[arr_columnnames objectAtIndex:counter]];
                    }
                    else if(sqlite3_column_type(compiled_stmt, counter)==SQLITE_TEXT){
                        NSString *str = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiled_stmt, counter)] ;
                        str = [str stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
                        str = [str stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
                        str = [str stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
                        str = [str stringByReplacingOccurrencesOfString:@"%2b" withString:@"+"];
                        [rowvalue setObject:str forKey:[arr_columnnames objectAtIndex:counter]];
                    }
                    else if (sqlite3_column_type(compiled_stmt, counter)==SQLITE_FLOAT){
                        NSString *str_coulmnfloat = [NSString stringWithFormat:@"%.2f",(float)sqlite3_column_double(compiled_stmt, counter)];
                        [rowvalue setObject:str_coulmnfloat forKey:[arr_columnnames objectAtIndex:counter]];
                    }
                    else if (sqlite3_column_type(compiled_stmt, counter)==SQLITE_NULL){
                        [rowvalue setObject:@"" forKey:[arr_columnnames objectAtIndex:counter]];
                    }
                    [db_arr addObject:rowvalue];
                }
            }
        }
        else{
            //show alert
            NSString *str_Error = [NSString stringWithFormat:@"%s", sqlite3_errmsg(databse)];
            [self errorInDatabase:str_Error];
        }
        sqlite3_finalize(compiled_stmt);
    }
    
    sqlite3_close(databse);
    
    return db_arr;
}

+ (BOOL)editFromDBwithQuery:(NSString*)query{
    BOOL Result = false;
    
    NSString *str_dbpath = [self pathOfDatabse];
    sqlite3 *database;
    sqlite3_stmt *compiled_stmt;
    const char *querystmt = [query UTF8String];
    
    if (sqlite3_open([str_dbpath UTF8String], &database) == SQLITE_OK) {
        if (sqlite3_prepare_v2(database, querystmt, -1, &compiled_stmt, NULL)) {
            return TRUE;
        }
        else{
            [self errorInDatabase:[NSString stringWithFormat:@"%s",sqlite3_errmsg(database)]];
        }
        sqlite3_finalize(compiled_stmt);
    }
    else{
        [self errorInDatabase:[NSString stringWithFormat:@"%s",sqlite3_errmsg(database)]];
    }
    
    sqlite3_close(database);
    
    return Result;
}

+(int)getRowCountFromDatabaseWithQry:(NSString*)query{
    int rowcount = 0;
    
    NSString *str_dbpath = [self pathOfDatabse];
    sqlite3 *databse;
    sqlite3_stmt *compiled_stmt;
    
    const char *querystr = [query UTF8String];
    
    if (sqlite3_open([str_dbpath UTF8String], &databse)==SQLITE_OK) {
        if (sqlite3_prepare_v2(databse, querystr, -1, &compiled_stmt, NULL)) {
            while (sqlite3_step(compiled_stmt)==SQLITE_ROW) {
                rowcount = sqlite3_column_int(compiled_stmt, 0);
            }
        }
        else{
              [self errorInDatabase:[NSString stringWithFormat:@"%s",sqlite3_errmsg(databse)]];
        }
        sqlite3_finalize(compiled_stmt);
    }
    else{
          [self errorInDatabase:[NSString stringWithFormat:@"%s",sqlite3_errmsg(databse)]];
    }
    sqlite3_close(databse);
    
    return rowcount;
}
+(void)addcoloumn:(NSString*)columnname intotable:(NSString*)tablename{
    
    NSString *str_DBPath = [self pathOfDatabse];
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    sqlite3_stmt *selectStmt;
    const char *sqlStatement =  [[NSString stringWithFormat:@"SELECT %@ FROM %@",columnname,tablename] UTF8String];
    
    if(sqlite3_open([str_DBPath UTF8String], &database) == SQLITE_OK)
    {
        if(!(sqlite3_prepare_v2(database, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)){
            NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE %@ ADD COLUMN %@",tablename,columnname];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"DB Altered");
            }
            else
            {
                NSLog(@"DB not Altered");
            }
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
        }
        
    }
}

+(void)errorInDatabase:(NSString *)errorMgs
{
    UIAlertView *alert_DB = [[UIAlertView alloc] initWithTitle:@"Database Error" message:errorMgs delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert_DB show];
}
@end
