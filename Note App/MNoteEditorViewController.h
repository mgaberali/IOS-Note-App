//
//  MNoteEditorViewController.h
//  Note App
//
//  Created by JETS on 5/13/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNote.h"
#import "MDBManager.h"

@interface MNoteEditorViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textEditor;
@property (strong, nonatomic) MNote *note;

- (IBAction)saveNote:(id)sender;

@end
