#import "ResourceListController.h"
#import "ParfaitAppDelegate.h"
#import "ResourceViewController.h"

@interface ResourceListController ()
@property (retain) ResourceViewController* showController;
@property (retain) NSArray* products;
@end

@implementation ResourceListController
- (void)dealloc
{
	self.showController = nil;
	self.products       = nil;
	[super dealloc];
}

- (Class)resourceClass;
{
	@throw [NSException exceptionWithName:@"NoResourceClass" reason:@"You must specify a resource class by subclassing -resourceClass." userInfo:nil];
	return nil;
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
	HANDLE_CONNECTION_EXCEPTIONS
	(
		self.products = [[self resourceClass] findAll:nil];
		[self.tableView reloadData];
	)
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
