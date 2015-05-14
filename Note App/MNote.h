//
//  MNote.h
//  Note App
//
//  Created by JETS on 5/13/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNote : NSObject

@property (strong) NSString *noteName;
@property (strong) NSString *lastModified;
@property int textSize;
@property int textBold;
@property int textItalic;
@property (strong) NSMutableString *noteText;

@end
