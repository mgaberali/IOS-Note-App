//
//  MNoteEditorViewController.m
//  Note App
//
//  Created by JETS on 5/13/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import "MNoteEditorViewController.h"

@interface MNoteEditorViewController ()

@end

@implementation MNoteEditorViewController{
    
    BOOL saved;
    BOOL saveOnBack;
    IBOutlet UIButton *saveBtn;
    

}

@synthesize textEditor, note;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    textEditor.delegate = self;
    saveOnBack = NO;
    
    if(note == nil){
        note = [MNote new];
        saved = NO;
        [saveBtn setEnabled:YES];
        
        [self.navigationItem setTitle:@"New Note"];
        
    }else{
        saved = YES;
        [textEditor setText:[note noteText]];
        [self.navigationItem  setTitle:[note noteName]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveNote:(id)sender {
    
    // ask about note name
    if([note noteName] == nil){
        
        [self askForNoteNameAlert];
    }else{
        // update note
        [self updateNoteInDB];
        
    }
    
    
}

- (void) askForNoteNameAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving" message:@"Enter note name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag == 1){
        
        if(buttonIndex == 1){
            UITextField *input = [alertView textFieldAtIndex:0];
            [note setNoteName:[input text]];
            
            // save note in db
            [self insertNoteInDB];
            
            // change nav bar title
            [self.navigationItem  setTitle:[note noteName]];
            
            if(saveOnBack){
                [[self navigationController] popViewControllerAnimated:YES];
            }
        
        }
        
    }else if (alertView.tag == 2){
        
        if(buttonIndex == 1){
            
            if([note noteName] == nil){
                saveOnBack = YES;
                [self askForNoteNameAlert];
                
            }else{
                [self updateNoteInDB];
                [[self navigationController] popViewControllerAnimated:YES];
            }
            
        }else{
            [[self navigationController] popViewControllerAnimated:YES];
        }
        
        
    }
    
}


- (void)textViewDidChange:(UITextView *)textView{
    
    saved = NO;
    [saveBtn setEnabled:YES];
    
}
- (IBAction)onBackButtonPressed:(id)sender {
    
    // ask for save if not saved before exit
    if(!saved){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Are you want to save this note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.tag = 2;
        [alert show];
        
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}

- (void) insertNoteInDB{
    
    // set note text
    [note setNoteText:[textEditor text]];
    
    // set note last modified date
    NSDateFormatter *formater = [[NSDateFormatter allocWithZone:NULL] init];
    formater.dateFormat = @"dd-MM-yyyy HH:mm";
    NSDate *date = [NSDate new];
    NSString *dateString = [formater stringFromDate:date];
    [note setLastModified:dateString];
    
    // set save flag by YES and disable save button
    saved = YES;
    [saveBtn setEnabled:NO];
    
    [[MDBManager getInstance] insertNote:note];
    
}

- (void) updateNoteInDB{
    
    // set note text
    [note setNoteText:[textEditor text]];
    
    // set note last modified date
    NSDateFormatter *formater = [[NSDateFormatter allocWithZone:NULL] init];
    formater.dateFormat = @"dd-MM-yyyy HH:mm";
    NSDate *date = [NSDate new];
    NSString *dateString = [formater stringFromDate:date];
    [note setLastModified:dateString];
    
    // set save flag by YES and disable save button
    saved = YES;
    [saveBtn setEnabled:NO];
    
    [[MDBManager getInstance] updateNote:note];
    
    
}


@end
