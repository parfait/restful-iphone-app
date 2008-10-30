#import "RootViewController.h"
#import "ParfaitAppDelegate.h"
#import "ResourceViewController.h"

@interface Product : ObjectiveResource
@end

@implementation Product
+ (NSString*)baseURL  { return @"http://caboose:monkeyballs@localhost:3000"; }

/*
- (NSArray*)interestingAttributeNames
{
	NSMutableArray* names = [[[super interestingAttributeNames] mutableCopy] autorelease];
	[names removeObject:@"created_at"];
	[names removeObject:@"updated_at"];
	return names;
}
*/
@end

@interface RootViewController ()
@property (retain) ResourceViewController* showController;
@property (retain) NSArray* products;
@end

@implementation RootViewController
- (void)dealloc
{
	self.showController = nil;
	self.products       = nil;
	[super dealloc];
}

- (Class)resourceClass;
{
	return [Product class];
}

@synthesize showController, products;

- (NSArray*)products;
{
	if(!products)
		[self refreshResourceList:nil];
	return products;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.products.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"ResourceListCell";

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];

	[cell setText:[[self.products objectAtIndex:indexPath.row] title]];

	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	// Navigation logic -- create and push a new view controller
	if(!self.showController)
	{
		ResourceViewController* controller = [[ResourceViewController alloc] init];
		self.showController = controller;
		[controller release];
	}
	self.showController.resource = [self.products objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:self.showController animated:YES];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshResourceList:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	self.title = [[[self resourceClass] collectionName] capitalizedString];
}

- (void)refreshResourceList:(id)sender;
{
	@try
	{
		self.products = [[self resourceClass] findAll:nil];
		[self.tableView reloadData];
	}
	@catch(ORResourceNotFound* error)
	{
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                          message:@"Error connecting to resource"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	@catch(ORConnectionError* error)
	{
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                          message:[error reason]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
