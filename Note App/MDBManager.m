//
//  MDBManager.m
//  Note App
//
//  Created by JETS on 5/14/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import "MDBManager.h"

static MDBManager *instance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation MDBManager


+ (MDBManager *) getInstance{
    
    if(!instance){
        instance = [[super allocWithZone:NULL] init];
        [instance createDB];
    }
    
    return instance;
}

- (BOOL) createDB{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    //databasePath = [[NSString alloc] initWithString:
    //                [docsDir stringByAppendingPathComponent: @"note.db"]];
    
    databasePath = @"/Users/participant/Desktop/Note App/Note App/note.db";
    
    BOOL isSuccess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:databasePath] == NO){
        
        const char *dbpath = [databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &database) == SQLITE_OK){
            
            char *errMsg;
            const char *sql_stmt = "create table if not exists note (note_name text primary key, last_modified text, text_size integer, text_bold integer, text_italic integer, note_text text)";
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
        
    }
    
    return isSuccess;
    
}

- (BOOL) insertNote: (MNote *) note{
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into note (note_name, last_modified, text_size, text_bold, text_italic, note_text) values(\"%@\",\"%@\", \"%d\", \"%d\", \"%d\", \"%@\")", [note noteName], [note lastModified], [note textSize], [note textBold], [note textItalic], [note noteText]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
            
        }
        else {
            return NO;
            
        }
        sqlite3_reset(statement);
    }
    return NO;
    
}
//
//- (MNote *) findNoteByName: (NSString *) noteName{
//
//}

- (NSMutableArray *) getAllNotes{
    
    NSMutableArray *notes = [NSMutableArray new];
    
    NSString *query = @"select * from note";
    
    const char *query_stmt = [query UTF8String];
    
    const char *dbpath = [databasePath UTF8String];
    
    
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                // get note name
                NSString *noteName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                // get last modified date
                NSString *lastModifiedDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                // get note text
                NSString *noteText = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                // get note size
                int noteSize = sqlite3_column_int(statement, 2);
                
                // get note bold
                int noteBold = sqlite3_column_int(statement, 3);
                
                // get note italic
                int noteItalic = sqlite3_column_int(statement, 4);
                
                MNote *note = [MNote new];
                [note setNoteName:noteName];
                [note setLastModified:lastModifiedDate];
                [note setTextSize:noteSize];
                [note setTextBold:noteBold];
                [note setTextItalic:noteItalic];
                [note setNoteText:noteText];
                
                [notes addObject:note];
                
            }
            
            sqlite3_reset(statement);
            
        }
        
    }
    
    
    return notes;
    
}

//
//- (NSArray *) searchNotesByText: (NSString *) searchText{
//
//}

- (BOOL) deleteNote: (NSString *) noteName{
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from note where note_name = \"%@\" ", noteName];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
            
        }
        else {
            return NO;
            
        }
        sqlite3_reset(statement);
    }
    return NO;
    
}


- (BOOL) updateNote: (MNote *) note{

    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"update note set last_modified = \"%@\", text_size = \"%d\", text_bold = \"%d\", text_italic = \"%d\", note_text = \"%@\" where note_name = \"%@\" ", [note lastModified], [note textSize], [note textBold], [note textItalic], [note noteText], [note noteName]];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(database, update_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
            
        }
        else {
            return NO;
            
        }
        sqlite3_reset(statement);
    }
    return NO;

    
}



@end
