//
//  QueryMethods.m
//  SQLlite Demo
//
//  Created by Femina Rajesh Brahmbhatt on 15/07/17.
//  Copyright © 2017 Femina Rajesh Brahmbhatt. All rights reserved.
//

#import "QueryMethods.h"

@implementation QueryMethods

+(BOOL)insertIntoTable:(NSString*)table WithFields:(NSString*)field andValues:(NSString*)values{
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",table,field,values];
    
    return [DBMethods editFromDBwithQuery:query];
}

+(BOOL)deleteFrom:(NSString*)table Where:(NSString*)condition{
    NSString *query;
    if (condition.length>0) {
        query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",table,condition];
    }
    else{
        query = [NSString stringWithFormat:@"DELETE FROM %@",table];
    }
    return [DBMethods editFromDBwithQuery:query];
}

+(NSMutableArray*)selectFrom:(NSString*)table Where:(NSString*)condition{
    NSString *query;

    if (condition.length>0) {
        query =  [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",table,condition];
    }
    else{
        query =  [NSString stringWithFormat:@"SELECT * FROM %@",table];
    }
    
    return [DBMethods selectFromDBwithSelectQuery:query];
    
}

+(NSMutableArray*)selectFrom:(NSString*)table Where:(NSString*)condition orderBy:(NSString*)order{
    NSString *query;
    if (condition.length>0) {
        query =  [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY %@",table,condition,order];
    }
    else{
        query =  [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@",table,order];
    }
    
    return [DBMethods selectFromDBwithSelectQuery:query];
}

+(BOOL)update:(NSString*)table set:(NSString*)setString Where:(NSString*)condition{
    NSString *query;
    if (condition.length>0) {
        query =  [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",table,setString,condition];
    }
    else{
        query =  [NSString stringWithFormat:@"UPDATE %@ SET %@",table,setString];
    }
    return [DBMethods editFromDBwithQuery:query];
}

+(int)getcountFor:(NSString*)table Where:(NSString*)condition{
    NSString *query;
    if (condition.length>0) {
        query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@",table,condition];
    }
    else{
        query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@",table,condition];
    }
    return [DBMethods editFromDBwithQuery:query];
}

+(NSString*)decodeStringforSQL:(NSString*)msg
{
    msg = [msg stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    return msg;
}

@end
