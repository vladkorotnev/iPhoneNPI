//
//  RootViewController.m
//  iNPI
//
//  Created by Vladislav on 26.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize currPkgName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    installSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Install", nil];
    areYouSureSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    NSString *cmd = [NSString stringWithFormat:@"chmod 755 %@",[[NSBundle mainBundle]pathForResource:@"unixnpi-armv7" ofType:nil]];
    system([cmd UTF8String]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)freshList {
    [self.tableView reloadData];
}
/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:@"/var/NPI" error:nil];
    return [array count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:@"/var/NPI" error:nil];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    [cell.textLabel setText:[array objectAtIndex:indexPath.row]];
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:@"/var/NPI" error:nil];
    currPkgName = [array objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [installSheet setTitle:[array objectAtIndex:indexPath.row]];
    [installSheet showInView:self.view];

}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:installSheet]) {
        switch (buttonIndex) {
            case 0:
                //del
                [areYouSureSheet setTitle:[NSString stringWithFormat:@"Are you sure that you want to delete %@?",currPkgName]];
                [areYouSureSheet showInView:self.view];
                break;
                
            case 1:
                //inst
                system([[NSString stringWithFormat:@"%@ -s 38400 -d /dev/cu.iap /var/NPI/%@",[[NSBundle mainBundle]pathForResource:@"unixnpi-armv7" ofType:nil],currPkgName]UTF8String]);
                process = [[UIActionSheet alloc]initWithTitle:@"Done" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
                [process showInView:self.view];
                [currPkgName release];
                break;
                
            default:
                [currPkgName release];
                break;
        }
    }
    
    if ([actionSheet isEqual:areYouSureSheet]) {
        switch (buttonIndex) {
            case 0:
                if ([[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"/var/NPI/%@",currPkgName] error:nil] != TRUE) {
                    UIActionSheet *fail = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"Failed to delete %@",currPkgName] delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
                    [fail showInView:self.view];
                }
                [self.tableView reloadData];
                
                [currPkgName release];
                break;
                
            default:
                [currPkgName release];
                break;
        }
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
