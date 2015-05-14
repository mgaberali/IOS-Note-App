//
//  MNotesListViewController.m
//  Note App
//
//  Created by JETS on 5/13/15.
//  Copyright (c) 2015 Mad. All rights reserved.
//

#import "MNotesListViewController.h"

@interface MNotesListViewController ()

@end

@implementation MNotesListViewController{
    
    NSMutableArray *notes;
    
    IBOutlet UITableView *tableViewOutlet;
    
    IBOutlet UISearchBar *searchBarOutlet;
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ************ test *************
//    MDBManager *mgr = [MDBManager getInstance];
////    MNote *m = [MNote new];
////    [m setNoteName:@"dsdsd"];
////    [m setNoteText:@"hello"];
////    [m setTextBold:1];
////    [m setTextItalic:1];
////    [m setTextSize:24];
////    [m setLastModified:[NSDate date]];
////    [mgr insertNote:m];
//    
//    NSArray *notes = [mgr getAllNotes];
//    MNote *note= [notes objectAtIndex:0];
//    [note setNoteName:@"my note"];
//    [mgr updateNote:note];
//    [mgr getAllNotes];
    // *******************************
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    // Configure the cell...
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    // Configure the cell...
    
    MNote *note = [notes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [note noteName];
    
    NSString *lastModifiedDate = @"Last modified: ";
    lastModifiedDate = [lastModifiedDate stringByAppendingString: [note lastModified]];
    
    cell.detailTextLabel.text = lastModifiedDate;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MNote *note = [notes objectAtIndex:indexPath.row];
        MDBManager *dbMgr = [MDBManager getInstance];
        
        if([dbMgr deleteNote:[note noteName]]){
            
            [notes removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
        
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    // load all notes from db
    MDBManager *dbMgr = [MDBManager getInstance];
    notes = [dbMgr getAllNotes];
    [tableViewOutlet reloadData];
    
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    MNote *note = [notes objectAtIndex:indexPath.row];
    
    // create Note Editor view controller
    MNoteEditorViewController *noteEditorViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"noteEditor"];
    [noteEditorViewController setNote:note];
    
    // Push the view controller.
    [self.navigationController pushViewController:noteEditorViewController animated:YES];
}


@end
