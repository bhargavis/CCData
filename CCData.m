//
//  CCData.m
//  Pocket Constitution
//
//  Created by James on 3/20/10.
//  Copyright 2010 Cirrostratus Design Company. All rights reserved.
//

#import "CCData.h"
#import "SQLiteAccess.h"
#import <Foundation/Foundation.h> 

@implementation CCData

- (NSArray *)dataForTable:(NSString *)t {
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", t];
	return [SQLiteAccess selectManyRowsWithSQL:sql];
}

- (NSArray *)dataForTable:(NSString *)t where:(NSString *)w equals:(NSString *)e {
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", t, w, e];
	DLog(@"%@",sql);
	return [SQLiteAccess selectManyRowsWithSQL:sql];
}


- (id)dataForTable:(NSString *)t where:(NSString *)w equals:(NSString *)e limitOne:(BOOL)limit;{
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", t, w, e];
	if (limit) {
		return [SQLiteAccess selectOneRowWithSQL:sql];
	}
	return [SQLiteAccess selectManyRowsWithSQL:sql];
}

- (NSArray *)dataForTable:(NSString *)t where:(NSString *)w matches:(NSString *)e {
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ MATCH '%@'", t, w, e];
	DLog(@"%@",sql);
	return [SQLiteAccess selectManyRowsWithSQL:sql];
}


- (NSArray *)dataForTable:(NSString *)t where:(NSString *)w equals:(NSString *)e isInt:(BOOL)b {
	if(!b){
		return [self dataForTable:t where:w equals:e];
	}
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %i", t, w, [e intValue]];
	DLog(@"%@",sql);
	return [SQLiteAccess selectManyRowsWithSQL:sql];
}

- (NSDictionary *)detailForID:(NSInteger)i inTable:(NSString *)t {
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = '%i'", t, i];
	return [SQLiteAccess selectOneRowWithSQL:sql];
}

- (void)deleteRowInTable:(NSString *)t byID:(NSInteger)i {
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = '%i'", t, i];
	return [SQLiteAccess deleteWithSQL:sql];
}

- (NSNumber *)insertRow:(NSMutableDictionary *)r inTable:(NSString *)t {
	DLog(@"insertRow");
	NSMutableString *mutable_sql = [[[NSMutableString alloc] initWithString:@""] autorelease];
	[mutable_sql appendString:[NSString stringWithFormat:@"INSERT INTO %@ (",t]];
	for (id theKey in r){
		[mutable_sql appendString:[NSString stringWithFormat:@"%@,",theKey]];
	}
	mutable_sql = [NSMutableString stringWithString:[mutable_sql substringToIndex:[mutable_sql length] - 1]];
	[mutable_sql appendString:@") VALUES ("];
	for (id theKey in r){
		[mutable_sql appendString:[NSString stringWithFormat:@"'%@',",[r objectForKey:theKey]]];
	}
	mutable_sql = [NSMutableString stringWithString:[mutable_sql substringToIndex:[mutable_sql length] - 1]];
	[mutable_sql appendString:@")"];
	return [SQLiteAccess insertWithSQL:[NSString stringWithString:mutable_sql]];
}

- (void)updateRow:(NSMutableDictionary *)r byID:(NSInteger)i inTable:(NSString *)t {
	NSMutableString *mutable_sql = [[[NSMutableString alloc] initWithString:@""] autorelease];
	[mutable_sql appendString:[NSString stringWithFormat:@"UPDATE %@ SET ",t]];
	for (id theKey in r){
		[mutable_sql appendString:[NSString stringWithFormat:@"%@ = '%@',",theKey,[r objectForKey:theKey]]];
	}
	mutable_sql = [NSMutableString stringWithString:[mutable_sql substringToIndex:[mutable_sql length] - 1]];
	[mutable_sql appendString:[NSString stringWithFormat:@"WHERE id = '%i'",i]];
	[SQLiteAccess updateWithSQL:[NSString stringWithString:mutable_sql]];
}

- (NSString *)arrayOfDictionariesToCSV:(NSArray *)arrayOfDictionaries {
	NSMutableString *itemsString = [[[NSMutableString alloc] init] autorelease];
	NSArray *items = arrayOfDictionaries;
	NSUInteger i, count = [items count];
	for (i = 0; i < count; i++) {
		if (i == 0) {
			NSArray *itemKeys = [[items objectAtIndex:i] allKeys];
			NSUInteger n, count2 = [itemKeys count];
			for (n = 0; n < count2; n++) {
				NSString *key = [itemKeys objectAtIndex:n];
				[itemsString appendString:key];
				if (n != count2-1) {
					[itemsString appendString:@","];
				} else {
					[itemsString appendString:@"\n"];
				}
			}
		}
		NSArray *itemValues = [[items objectAtIndex:i] allValues];
		NSUInteger j, count3 = [itemValues count];
		for (j = 0; j < count3; j++) {
			NSString *value = [itemValues objectAtIndex:j];
			[itemsString appendString:value];
			if (j != count3-1) {
				[itemsString appendString:@","];
			} else {
				[itemsString appendString:@"\n"];
			}
		}
		
	}
	return [NSString stringWithFormat:@"%@",itemsString];
}


@end