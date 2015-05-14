//
//  MDBManager.h
//  Note App
//
//  Created by JETS on 5/14/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MNote.h"

@interface MDBManager : NSObject{
    
    NSString *databasePath;
    
}

+ (MDBManager *) getInstance;
- (BOOL) createDB;
- (BOOL) insertNote: (MNote *) note;
- (MNote *) findNoteByName: (NSString *) noteName;
- (NSMutableArray *) getAllNotes;
- (NSArray *) searchNotesByText: (NSString *) searchText;
- (BOOL) deleteNote: (NSString *) noteName;
- (BOOL) updateNote: (MNote *) note;


@end
