//
//  TableViewController.m
//  CustomTableView
//
//  Created by wood on 4/30/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "TableViewController.h"
#import "Recipe.h"

static const char* images[] = {"mushroom_risotto.jpg", "egg_benedict.jpg", "full_breakfast.jpg", "hamburger.jpg", "ham_and_egg_sandwich.jpg"};
static const char* names[] = {"Mushroom Risotto", "Egg Benedict", "Full Breakfast", "Hamburger", "Ham and Egg Sandwich"};
static const char* details[] = { "20 min", "30 min", "20 min", "30 min", "10 min" };
//NSArray* images = @[@"mushroom_risotto.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg"];
//NSArray* names = @[@"Mushroom Risotto", @"Egg Benedict", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich"];
//NSArray* details = @[ @"20 min", @"30 min", @"20 min", @"30 min", @"10 min"];

@interface TableViewController ()
@end

// [NSString stringWithCString:"" encoding:NSUTF8StringEncoding];

@implementation TableViewController {
    NSMutableArray *recipes;
}

- (IBAction)clickMe:(UIBarButtonItem *)sender {
    NSIndexPath* idxp = [NSIndexPath indexPathForRow:recipes.count inSection:0];
    
    time_t ct = time(0);
    const int Numb = sizeof(images)/sizeof(images[0]);
    int i = rand() % Numb;
    Recipe *newr = [Recipe new];
    newr.name = [NSString stringWithCString: names[i % Numb] encoding:NSUTF8StringEncoding];
    newr.imageFile = [NSString stringWithCString: images[i % Numb] encoding:NSUTF8StringEncoding];
    //newr.detail = [NSString stringWithCString: details[i % Numb] encoding:NSUTF8StringEncoding];
    char cts[64];
    strftime(cts, sizeof(cts), "%T %F", localtime(&ct));
    newr.detail = [NSString stringWithCString: cts encoding:NSUTF8StringEncoding];
    //newr.detail = [NSString stringWithCString: ctime(&ct) encoding:NSUTF8StringEncoding];
    
    [recipes addObject:newr];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:idxp] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:idxp atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //[self.tableView beginUpdates];
    //NSIndexPath* ix3 = [NSIndexPath indexPathForRow:3 inSection:0];
    //NSIndexPath* ix0 = [NSIndexPath indexPathForRow:0 inSection:0];
    // [self.tableView moveRowAtIndexPath:fr toIndexPath:ix0];
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ix3] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ix0] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ix3] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
    // deleteRowsAtIndexPaths removeLastObject
    
    //NSIndexPath* idxp = [NSIndexPath indexPathForRow:[recipes count]-1 inSection:0];
    //[ self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:idxp];
    
    //[self.tableView setEditing:YES animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    return proposedDestinationIndexPath;
//}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id r = [recipes objectAtIndex:sourceIndexPath.row];
    [recipes removeObjectAtIndex:sourceIndexPath.row];
    [recipes insertObject:r  atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [recipes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    //if (editingStyle == UITableViewCellEditingStyleInsert) { }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    const int Numb = sizeof(images)/sizeof(images[0]);
    recipes = [[NSMutableArray alloc] init ];
    for (int i=0; i<Numb; ++i) {
        Recipe *r = [Recipe new];
        r.name = [NSString stringWithCString: names[i % Numb] encoding:NSUTF8StringEncoding];
        r.detail = [NSString stringWithCString: details[i % Numb] encoding:NSUTF8StringEncoding];
        r.imageFile = [NSString stringWithCString: images[i % Numb] encoding:NSUTF8StringEncoding];
        [recipes addObject:r];
    }
    
    //self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //self.tableView.allowsSelectionDuringEditing = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self->recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Recipe* recipe = [recipes objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"Cell"];
    }
    UIImageView *image = (UIImageView*)[cell viewWithTag:100];
    UILabel *name = (UILabel*)[cell viewWithTag:101];
    UILabel *detail = (UILabel*)[cell viewWithTag:102];
    image.image = [UIImage imageNamed:recipe.imageFile]; //[[UIImage alloc] initWithContentsOfFile:recipe.imageFile];
    name.text = recipe.name;
    detail.text = recipe.detail;
    
    //UIImage *bg = self cell
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
